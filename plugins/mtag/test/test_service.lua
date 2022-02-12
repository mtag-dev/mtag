local mtag_service = require("plugins.mtag.service")


describe("service", function()
  describe("proper", function()
    it("static endpoints processing", function()
      local config = {
        name = "my_service",
        endpoints = {
          {
            method = "POST",
            path = "/user",
            permission = "service:user:add",
            allow_anonymous = false
          },
          {
            method = "GET",
            path = "/tomatoes",
            permission = "service:tomatoes:get",
            allow_anonymous = false
          }
        }
      }

      local res, err
      local service = mtag_service:new()
      res, err = service:configure(config)
      assert.is_true(res)
      assert.is_nil(err)

      res, err = service:resolve("POST", "/user")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:user:add")
      assert.is_false(res.allow_anonymous)

      res, err = service:resolve("GET", "/tomatoes")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:tomatoes:get")
      assert.is_false(res.allow_anonymous)
    end)

    it("dynamic endpoints without validators", function()
      local config = {
        name = "my_service",
        endpoints = {
          {
            method = "PATCH",
            path = "/user/{user_id}",
            permission = "service:user:edit",
            allow_anonymous = false
          }
        }
      }

      local res, err
      local service = mtag_service:new()
      res, err = service:configure(config)
      assert.is_true(res)
      assert.is_nil(err)

      -- integer parameter
      res, err = service:resolve("PATCH", "/user/123")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:user:edit")
      assert.is_false(res.allow_anonymous)

      -- string parameter
      res, err = service:resolve("PATCH", "/user/john")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:user:edit")
      assert.is_false(res.allow_anonymous)
    end)

    it("dynamic endpoints with validators", function()
      local config = {
        name = "my_service",
        validators = {
          int = "^[0-9]+$",
          uuid = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
        },
        endpoints = {
          {
            method = "PATCH",
            path = "/user/{user_id:int}",
            permission = "service:user:edit",
            allow_anonymous = false
          },
          {
            method = "DELETE",
            path = "/item/{item_id:uuid}",
            permission = "service:item:delete",
            allow_anonymous = false
          }
        }
      }

      local res, err
      local service = mtag_service:new()
      res, err = service:configure(config)
      assert.is_true(res)
      assert.is_nil(err)

      -- integer parameter
      res, err = service:resolve("PATCH", "/user/123")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:user:edit")
      assert.is_false(res.allow_anonymous)

      -- string parameter
      res, err = service:resolve("PATCH", "/user/john")
      assert.is_nil(res)
      assert.is_nil(err)

      -- uuid parameter
      res, err = service:resolve("DELETE", "/item/7a44bddf-17c5-4fb3-9e9c-658bb558daa4")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:item:delete")
      assert.is_false(res.allow_anonymous)

      -- int parameter
      res, err = service:resolve("DELETE", "/item/123")
      assert.is_nil(res)
      assert.is_nil(err)
    end)

    it("root endpoint", function()
      local config = {
        name = "my_service",
        endpoints = {
          {
            method = "GET",
            path = "/",
            permission = "service:root",
            allow_anonymous = false
          }
        }
      }

      local res, err
      local service = mtag_service:new()
      res, err = service:configure(config)
      assert.is_true(res)
      assert.is_nil(err)

      -- resolved
      res, err = service:resolve("GET", "/")
      assert.is_nil(err)
      assert.is_equal(res.permission, "service:root")
      assert.is_false(res.allow_anonymous)

      -- not registered method
      res, err = service:resolve("DELETE", "/")
      assert.is_nil(res)
      assert.is_nil(err)

      -- not a location
      res, err = service:resolve("GET", "/unknown")
      assert.is_nil(res)
      assert.is_nil(err)
    end)

    it("locations", function()

    end)

    it("root location", function()

    end)

    it("ignore trailing slashes mode", function()

    end)

    it("service superuser", function()

    end)
  end)

  describe("configure negative", function()
    it("wrong validator", function()

    end)

    it("unknown validator", function()

    end)

    it("absent validator", function()

    end)

    it("invalid path", function()

    end)

    it("multiple errors", function()

    end)
  end)
end)

