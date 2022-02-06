from squall import Squall

import gateway

app = Squall()

app.include_router(gateway.router)
