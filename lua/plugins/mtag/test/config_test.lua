

insulate("config", function()
  describe("controller", function()
    it("valid configuration", function()
       stub(os, "getenv")
       os.getenv.on_call_with("MTAG_CONTROLLER_HOST").returns("controller:81")
       os.getenv.on_call_with("MTAG_CONTROLLER_PREFIX").returns(nil)
       os.getenv.on_call_with("MTAG_CONTROLLER_SECRET").returns(" ")
       os.getenv.on_call_with("MTAG_CONTROLLER_SSL").returns("true ")
       os.getenv.on_call_with("MTAG_CONTROLLER_SSL_VERIFY").returns(" false")

       local config = require("plugins.mtag.config")
       assert.is_equal(config.controller.host, "controller:81")
       assert.is_equal(config.controller.prefix, "")
       assert.is_equal(config.controller.secret, " ")
       assert.is_equal(config.controller.ssl, true)
       assert.is_equal(config.controller.ssl_verify, false)
    end)
  end)
end)