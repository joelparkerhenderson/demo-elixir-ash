defmodule DemoElixirAsh.MyDomain do
  use Ash.Domain,
    otp_app: :demo_elixir_ash

  resources do
    resource DemoElixirAsh.MyDomain.Item
  end
end
