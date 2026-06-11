defmodule Das.MixProject do
  use Mix.Project

  def project do
    [
      app: :das,
      version: "1.0.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      config_providers: [
        {Config.Reader, "config/config.exs"}
      ],
      releases: [
        das: [
          version: "1.0",
          applications: [das: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Das, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.14.0"},
      {:ecto_sql, "~>3.14.0"},
      {:myxql, "~>0.9.0"},
      {:postgrex, "~>0.22.2"},
      {:ecto_sqlite3, "~>0.24.0"},
      {:bcrypt_elixir, "~> 3.3.2"},
      {:plug_cowboy, "~> 2.8.1"},
      {:jason, "~> 1.4.5"},
      {:ldap_asn, path: "ldap_asn/", manager: :rebar3},
      {:joken, "~> 2.6.2"},
      {:castore, "~> 1.0.19"},
      {:mint, "~> 1.8.0"},
      {:nimble_totp, "~> 1.0"},
      {:eqrcode, "~> 0.2.1"},
    ]
  end
end
