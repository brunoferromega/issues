defmodule Issues.GithubIssues do
  @github_url Application.compile_env(:issues, :github_url)
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(user, project), do: "#{@github_url}/repos/#{user}/#{project}/issues"

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_status(),
      body |> Poison.Parser.parse!()
    }
  end

  defp check_status(200), do: :ok
  defp check_status(_), do: :erro
end
