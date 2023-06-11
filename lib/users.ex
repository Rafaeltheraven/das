defmodule Users do

  import Ecto.Query

  @moduledoc """
  All function required to operate on the user database
  """

  @doc """
  Gets all the users
  """
  def get_all() do
    repo = Storage.get()
    query = from u in Users.User
    repo.all(query)
  end
  
  @doc """
  Gets a single user that matches the id
  """
  def get_by_id(id) do
    query = from u in Users.User,
      where: u.id == ^id
    repo = Storage.get()
    repo.one(query)
  end


  @doc """
  Gets a single user that matches the username
  """
  def get_by_username(username) do
    query = from u in Users.User,
      where: u.username == ^username
    repo = Storage.get()
    repo.one(query)
  end

  @doc """
  Verifies that the user is who they say they are given the provided credentials.
  Returns nil if incorrect (including if the user does not exist, etc.)
  Returns the user object if credentials are correct.
  """
  def verify(username, password, opts \\ []) do
    user = get_by_username(username)
    ldap = if opts[:ldap] == nil do false else opts[:ldap] end
    cond do
      user == nil -> nil
      ldap and user.totp_ldap and user.totp_secret != nil -> 
        totp_code = String.slice(password, -6..-1)
        password = String.slice(password, 0..-7//1)
        pass_check = Bcrypt.verify_pass(password, user.password)
        totp_check = NimbleTOTP.valid?(user.totp_secret, totp_code)
        if pass_check and totp_check do user else nil end

      Bcrypt.verify_pass(password, user.password) -> user
      true -> nil
    end
  end
end
