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
      server: :second
    }
  }
  def traditional(serves) do
    IO.inspect(@state)

    Enum.reduce(Range.new(1, serves), @state, fn _i, acc ->
      point_winner = Enum.random([:a, :b])
      acc = point_won(point_winner, acc)

      IO.inspect(acc)
    end)
  end

  defp point_won(team = :a, %{serving: %{team: :a}} = state) do
    server_won(team, state)
  end

  defp point_won(team = :b, %{serving: %{team: :b}} = state) do
    server_won(team, state)
  end

  defp point_won(team = :a, %{serving: %{team: :b}} = state) do
    receiver_won(team, state)
  end

  defp point_won(team = :b, %{serving: %{team: :a}} = state) do
    receiver_won(team, state)
  end

  defp server_won(team, state) do
    state
    |> update_in([:score, team], &(&1 + 1))
    |> update_in([:positions, team], fn p -> %{right: p.left, left: p.right} end)
  end

  def receiver_won(_team, %{serving: %{server: :first}} = state) do
    state
    |> put_in([:serving, :server], :second)
  end

  def receiver_won(team, %{serving: %{server: :second}} = state) do
    state
    |> put_in([:serving, :team], team)
    |> put_in([:serving, :server], :first)
  end
end

Scoring.traditional(100)
