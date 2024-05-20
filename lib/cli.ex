defmodule Issues.Cli do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the varius functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv), do: parse_args(argv)

  @doc """
  `argv` can be -h or --help which returns :help
  Otherwise it is a github user name, project name and
  (optionally) the number of the entries to format
  Return a tuple of `{user, project, count}` , or :help if help was given
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation([user, project, count]),
    do: {user, project, String.to_integer(count)}

  defp args_to_internal_representation([user, project]), do: {user, project, @default_count}
  defp args_to_internal_representation(_), do: :help
end
