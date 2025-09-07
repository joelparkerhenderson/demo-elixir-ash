defmodule DemoElixirAsh.MyDomain.Item do
  use Ash.Resource,
    otp_app: :demo_elixir_ash,
    domain: DemoElixirAsh.MyDomain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "items"
    repo DemoElixirAsh.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name, :note], update: [:name, :note]]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :note, :string do
      public? true
    end

    timestamps()
  end
end
