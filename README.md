# Demo Elixir Ash

Demonstration of:

- [Elixir](https://?) programming language
- [Ash](https://hexdocs.pm/ash/) resource domain modeler
- [AshPhoenix](https://hexdocs.pm/ash_phoenix/) Phoenix framework layer
- [AshPostgres](https://hexdocs.pm/ash_postgres/) Postgres database layer
- [Igniter](https://hexdocs.pm/igniter/) code generation framework

## How to run this

Start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

Learn more:

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

## How to build this project from scratch

The rest of this page is a tutorial that teaches how to build this project from scratch.

For the tutorial, we use the fake app name "MyApp". In this repo, the real app name is "DemoElixirAsh".

For the tutorial, we use the fake app domain name "MyDomain".

## Install dependencies

Install Erlang, Elixir, Postgres any way you like, such as via mise:

```sh
mise use erlang@latest 
mise use elixir@latest 
mise use postgres@latest
```

Install Phoenix web framework and Igniter code generation framework:

```sh
mix archive.install hex phx_new
mix archive.install hex igniter_new
```

## Create a new application

Create a new Elixir Ash Phoenix Postgres application:

```sh
mix igniter.new my_app --with phx.new --install ash,ash_phoenix,ash_postgres
cd my_app
mix ash.setup
```

<details>
  <summary>Output</summary>

```stdout
Getting extensions in current project...
Running setup for AshPostgres.DataLayer...
The database for DemoElixirAsh.Repo has been created

17:43:40.851 [info] == Running 20250907154907 DemoElixirAsh.Repo.Migrations.InitializeExtensions1.up/0 forward

17:43:40.853 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_or(left BOOLEAN, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE)\nAS $$ SELECT COALESCE(NULLIF($1, FALSE), $2) $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

17:43:40.853 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_or(left ANYCOMPATIBLE, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE)\nAS $$ SELECT COALESCE($1, $2) $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

17:43:40.854 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_and(left BOOLEAN, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE) AS $$\n  SELECT CASE\n    WHEN $1 IS TRUE THEN $2\n    ELSE $1\n  END $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

17:43:40.854 [info] execute "CREATE OR REPLACE FUNCTION ash_elixir_and(left ANYCOMPATIBLE, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE) AS $$\n  SELECT CASE\n    WHEN $1 IS NOT NULL THEN $2\n    ELSE $1\n  END $$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE;\n"

17:43:40.854 [info] execute "CREATE OR REPLACE FUNCTION ash_trim_whitespace(arr text[])\nRETURNS text[] AS $$\nDECLARE\n    start_index INT = 1;\n    end_index INT = array_length(arr, 1);\nBEGIN\n    WHILE start_index <= end_index AND arr[start_index] = '' LOOP\n        start_index := start_index + 1;\n    END LOOP;\n\n    WHILE end_index >= start_index AND arr[end_index] = '' LOOP\n        end_index := end_index - 1;\n    END LOOP;\n\n    IF start_index > end_index THEN\n        RETURN ARRAY[]::text[];\n    ELSE\n        RETURN arr[start_index : end_index];\n    END IF;\nEND; $$\nLANGUAGE plpgsql\nSET search_path = ''\nIMMUTABLE;\n"

17:43:40.878 [info] execute "CREATE OR REPLACE FUNCTION ash_raise_error(json_data jsonb)\nRETURNS BOOLEAN AS $$\nBEGIN\n    -- Raise an error with the provided JSON data.\n    -- The JSON object is converted to text for inclusion in the error message.\n    RAISE EXCEPTION 'ash_error: %', json_data::text;\n    RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql\nSTABLE\nSET search_path = '';\n"

17:43:40.878 [info] execute "CREATE OR REPLACE FUNCTION ash_raise_error(json_data jsonb, type_signal ANYCOMPATIBLE)\nRETURNS ANYCOMPATIBLE AS $$\nBEGIN\n    -- Raise an error with the provided JSON data.\n    -- The JSON object is converted to text for inclusion in the error message.\n    RAISE EXCEPTION 'ash_error: %', json_data::text;\n    RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql\nSTABLE\nSET search_path = '';\n"

17:43:40.878 [info] execute "CREATE OR REPLACE FUNCTION uuid_generate_v7()\nRETURNS UUID\nAS $$\nDECLARE\n  timestamp    TIMESTAMPTZ;\n  microseconds INT;\nBEGIN\n  timestamp    = clock_timestamp();\n  microseconds = (cast(extract(microseconds FROM timestamp)::INT - (floor(extract(milliseconds FROM timestamp))::INT * 1000) AS DOUBLE PRECISION) * 4.096)::INT;\n\n  RETURN encode(\n    set_byte(\n      set_byte(\n        overlay(uuid_send(gen_random_uuid()) placing substring(int8send(floor(extract(epoch FROM timestamp) * 1000)::BIGINT) FROM 3) FROM 1 FOR 6\n      ),\n      6, (b'0111' || (microseconds >> 8)::bit(4))::bit(8)::int\n    ),\n    7, microseconds::bit(8)::int\n  ),\n  'hex')::UUID;\nEND\n$$\nLANGUAGE PLPGSQL\nSET search_path = ''\nVOLATILE;\n"

17:43:40.879 [info] execute "CREATE OR REPLACE FUNCTION timestamp_from_uuid_v7(_uuid uuid)\nRETURNS TIMESTAMP WITHOUT TIME ZONE\nAS $$\n  SELECT to_timestamp(('x0000' || substr(_uuid::TEXT, 1, 8) || substr(_uuid::TEXT, 10, 4))::BIT(64)::BIGINT::NUMERIC / 1000);\n$$\nLANGUAGE SQL\nSET search_path = ''\nIMMUTABLE PARALLEL SAFE STRICT;\n"

17:43:40.880 [info] == Migrated 20250907154907 in 0.0s
```

</details>

## Create a resource

Create a resource of any kind, such as an item, with our preferred options:

```sh
mix ash.gen.resource MyApp.MyDomain.Item \
--uuid-v7-primary-key id \
--timestamps \
--default-actions create,read,update,destroy \
--attribute name:string:required:public \
--attribute note:string:public \
--extend postgres
```

<details>
  <summary>Explanation</summary>

- `--uuid-v7-primary-key` - Add a UUIDv7 primary key with the given name. 

  - Example: `--uuid-v7-primary-key id`

- `--timestamps` - Add timestamps as attributes `inserted_at` and `updated_at`.

- `--default-actions` - A comma-separated list of default action types to add. The create and update actions accept the public attributes being added.
  
  - Example: `--default-actions create,read,update,destroy`. 

- `--extend` - A comma -eparated list of modules or builtins with which to extend the resource. 

  - Example: `--extend postgres,graphql,Some.Extension`

</details>

<details>
  <summary>Output</summary>

Update: <config/config.exs>

```stdout
       ...|
 46  46   |config :my_app,
 47  47   |  ecto_repos: [MyApp.Repo],
 48     - |  generators: [timestamp_type: :utc_datetime]
     48 + |  generators: [timestamp_type: :utc_datetime],
     49 + |  ash_domains: [MyApp.MyDomain]
 49  50   |
 50  51   |# Configures the endpoint
       ...|
```

Create: <lib/my_app/my_domain.ex>

```elixir
defmodule MyApp.MyDomain do
  use Ash.Domain,
    otp_app: :my_app

  resources do
    resource MyApp.MyDomain.Item
  end
end
```

Create: <lib/my_app/my_domain/item.ex>

```elixir
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
```

</details>

## Migrate

Generate the migration:

```sh
mix ash.codegen create_items
```

<details>
  <summary>Output</summary>

```stdout
Compiling 17 files (.ex)
Generated demo_elixir_ash app
Getting extensions in current project...
Running codegen for AshPostgres.DataLayer...
* creating priv/repo/migrations/20250907164015_create_items.exs
* creating priv/resource_snapshots/repo/items/20250907164015.json
```

</details>

Run the migration:

```sh
mix ash.migrate
```

<details>
  <summary>Output</summary>

```stdout
17:43:40.904 [info] == Running 20250907164015 DemoElixirAsh.Repo.Migrations.CreateItems.up/0 forward

17:43:40.904 [info] create table items

17:43:40.916 [info] == Migrated 20250907164015 in 0.0s
```

</details>

## Router

Edit file <lib/my_app_web/router.ex> to add these live routes:

```elixir
scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/items", Items.IndexLive
    live "/items/new", Items.FormLive, :new
    live "/items/:id", Items.ShowLive
    live "/items/:id/edit", Items.FormLive, :edit
end
```

## LiveView

Run:

```sh
mkdir -p lib/my_app_web/live/items
```

Create files:

- <lib/my_app_web/live/items/index_live.ex>

- <lib/my_app_web/live/items/show_live.ex>

- <lib/my_app_web/live/items/form_live.ex>

### Helpful concepts

`Ash.get!` is a convenience function for running a read action, filtering by a
unique identifier, and expecting only a single result. It is equivalent to the
following code:

`Ash.read_one!` is convenience function when you expect an action to return only
a single result, and want to enforce that and return a single result.

## Use Ash macros

Edit `lib/my_app/my_domain.ex`.

Add code:

```elixir
defmodule MyApp.MyDomain do

    # Use Ash extensions for Phoenix so we can use syntax sugar.
    #
    # Example query with sugar:
    #
    #     items = MyApp.MyDomain.items_read!()
    #
    # Example query without sugar:
    #
    #     items = DemoElixirAsh.MyDomain.Item
    #     |> Ash.Query.for_read(:read)
    #     |> Ash.read!()
    #
    # Example form with sugar:
    #
    #     MyApp.MyDomain.form_to_item_create
    #
    # Example form without sugar:
    #
    #     AshPhoenix.Form.for_create(MyApp.MyDomain.Item, :create)
    #
    use Ash.Domain, otp_app: :my_app, extensions: [AshPhoenix]
    resources do
        resource MyApp.MyDomain.item do
            define :item_create, action: :create
            define :item_read, action: :read
            define :item_read_id, action: :read, get_by: :id
            define :item_update, action: :update
            define :item_destroy, action: :destroy
        end
    end
end
```


## The rest of this page has extra notes

The rest of this page has extra notes that are helping me learn and teach Ash.

If you're solely interested in the demo app, then you can stop reading here.

## Actions

### Add default actions

Ash comes with default actions for create, read, update, destroy.

Ash comes with default accept attributes, which means the create action and update action will automatically use all the resource's public attributes.

Edit `lib/my_app/my_domain/item.ex`.

```elixir
actions do
  defaults [:create, :read, :update, :destroy]
  default_accept [:name, :note]
end
```


### Add custom actions

If you prefer to define your own actions, you can.

Edit `lib/my_app/my_domain/item.ex`.

Add your own actions via code:

```elixir
actions do

  create :create do
    accept [:name, :note]
  end

  read :read do
    primary? true
  end

  update :update do
    accept [:name, :note]
  end

  destroy :destroy do
  end

end
```
