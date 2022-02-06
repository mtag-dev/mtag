from squall import Router

from . import v1


router = Router(prefix="/gateway")
router.include_router(v1.router)
