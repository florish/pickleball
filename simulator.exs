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
  def traditional(serves) do
    Enum.reduce(Range.new(1, serves), @state, fn _i, state ->
      point_winner = Enum.random([:a, :b])

      state =
        state
        |> update_serves()
        |> IO.inspect()

      IO.puts("point winner: #{point_winner}")

      state
      |> point_won(point_winner)
    end)
  end

  defp update_serves(state) do
    team = state.serving.team
    side = state.serving.side
    player = state.positions[team][side]

    update_in(state, [:serves, team, player, side], &(&1 + 1))
  end

  defp point_won(%{serving: %{team: :a}} = state, team = :a) do
    server_won(state, team)
  end

  defp point_won(%{serving: %{team: :b}} = state, team = :b) do
    server_won(state, team)
  end

  defp point_won(%{serving: %{team: :b}} = state, team = :a) do
    receiver_won(state, team)
  end

  defp point_won(%{serving: %{team: :a}} = state, team = :b) do
    receiver_won(state, team)
  end

  defp server_won(state, team) do
    state
    |> update_in([:score, team], &(&1 + 1))
    |> update_in([:positions, team], fn p -> %{right: p.left, left: p.right} end)
    |> switch_serving_side()
  end

  defp switch_serving_side(%{serving: %{side: :right}} = state) do
    state
    |> put_in([:serving, :side], :left)
  end

  defp switch_serving_side(%{serving: %{side: :left}} = state) do
    state
    |> put_in([:serving, :side], :right)
  end

  defp receiver_won(%{serving: %{server: :first}} = state, _team) do
    state
    |> put_in([:serving, :server], :second)
    |> switch_serving_side()
  end

  defp receiver_won(%{serving: %{server: :second}} = state, team) do
    state
    |> put_in([:serving, :team], team)
    |> put_in([:serving, :server], :first)
    |> put_in([:serving, :side], :right)
  end
end

Scoring.traditional(1_000_000)
