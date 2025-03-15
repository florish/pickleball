defmodule Scoring do
  @state %{
    positions: %{
      a: %{
        right: 1,
        left: 2
      },
      b: %{
        right: 1,
        left: 2
      }
    },
    score: %{
      a: 0,
      b: 0
    },
    serving: %{
      team: :a,
      server: :second,
      side: :right
    },
    serves: %{
      a: %{
        1 => %{right: 0, left: 0},
        2 => %{right: 0, left: 0}
      },
      b: %{
        1 => %{right: 0, left: 0},
        2 => %{right: 0, left: 0}
      }
    }
  }

  defmodule Helpers do
    def increment_score(state, team) do
      state
      |> update_in([:score, team], &(&1 + 1))
    end

    def switch_positions(state, team) do
      state
      |> update_in([:positions, team], fn p -> %{right: p.left, left: p.right} end)
    end

    def switch_serving_side(%{serving: %{side: :right}} = state) do
      state
      |> put_in([:serving, :side], :left)
    end

    def switch_serving_side(%{serving: %{side: :left}} = state) do
      state
      |> put_in([:serving, :side], :right)
    end

    def award_service(state, team) do
      state
      |> put_in([:serving, :team], team)
    end
  end

  defmodule Traditional do
    import Helpers

    def server_won(state, team) do
      state
      |> increment_score(team)
      |> switch_positions(team)
      |> switch_serving_side()
    end

    def receiver_won(%{serving: %{server: :first}} = state, _team) do
      state
      |> put_in([:serving, :server], :second)
      |> switch_serving_side()
    end

    def receiver_won(%{serving: %{server: :second}} = state, team) do
      state
      |> award_service(team)
      |> put_in([:serving, :server], :first)
      |> put_in([:serving, :side], :right)
    end
  end

  defmodule Rally do
    import Helpers
    require Integer

    def server_won(state, team) do
      state
      |> increment_score(team)
      |> switch_positions(team)
      |> switch_serving_side()
    end

    def receiver_won(state, team) do
      state
      |> increment_score(team)
      |> award_service(team)
      |> maybe_switch_positions(team)
      |> put_in([:serving, :side], :right)
    end

    # defp maybe_switch_positions(
    #        %{score: %{^team => team_score}, positions: %{^team => %{right: 1, left: 2}}} = state,
    #        team
    #      )
    #      when is_odd(team_score) do
    #   state
    #   |> switch_positions(team)
    # end

    defp maybe_switch_positions(%{score: score, positions: positions} = state, team) do
      if (Integer.is_odd(score[team]) && positions[team][:right] == 1) ||
           (Integer.is_even(score[team]) && positions[team][:right] == 2) do
        state
        |> switch_positions(team)
      else
        state
      end
    end
  end

  def traditional(count), do: run(Traditional, count)

  def rally(count), do: run(Rally, count)

  defp run(module, count) do
    Enum.reduce(Range.new(1, count), @state, fn _i, state ->
      point_winner = Enum.random([:a, :b])

      state =
        state
        |> update_serves()
        |> IO.inspect()

      IO.puts("point winner: #{point_winner}")

      state
      |> point_won(point_winner, module)
    end)
  end

  defp update_serves(state) do
    team = state.serving.team
    side = state.serving.side
    player = state.positions[team][side]

    update_in(state, [:serves, team, player, side], &(&1 + 1))
  end

  defp point_won(%{serving: %{team: :a}} = state, team = :a, module) do
    module.server_won(state, team)
  end

  defp point_won(%{serving: %{team: :b}} = state, team = :b, module) do
    module.server_won(state, team)
  end

  defp point_won(%{serving: %{team: :b}} = state, team = :a, module) do
    module.receiver_won(state, team)
  end

  defp point_won(%{serving: %{team: :a}} = state, team = :b, module) do
    module.receiver_won(state, team)
  end
end

[type, count] = System.argv()
count = String.to_integer(count)

case type do
  "traditional" -> Scoring.traditional(count)
  "rally" -> Scoring.rally(count)
end
