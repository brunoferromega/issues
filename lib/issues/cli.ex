defmodule Issues.Cli do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the varius functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

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

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decoder_response()
    |> sort_desc()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decoder_response({:ok, body}), do: body

  def decoder_response({:error, error}) do
    IO.puts("Error fetching from of Github #{error["message"]}")
    System.halt(0)
  end

  def sort_desc(issues_list) do
    issues_list
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end
end
