load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

# UNTAPPD API KEYS
UNTAPPD_CLIENT_ID = ""
UNTAPPD_SECRET_ID = ""

# UNTAPPD USER
UNTAPPD_USER = ""

# API ENDPOINTS
UNTAPPD_USER_FEED = "https://api.untappd.com/v4/user/checkins/" + UNTAPPD_USER + "?client_id=" + UNTAPPD_CLIENT_ID + "&client_secret=" + UNTAPPD_SECRET_ID
UNTAPPD_USER_INFO = "https://api.untappd.com/v4/user/info/" + UNTAPPD_USER + "?client_id=" + UNTAPPD_CLIENT_ID + "&client_secret=" + UNTAPPD_SECRET_ID

# CACHE KEYS
KEY_BREWERY = "brewery"
KEY_BEER = "beer"
KEY_NUMBER_OF_BEERS = "number_of_beers"

# ICON BASE64
UNTAPPD_LOGO = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAACeUlEQVQ4jY3V34tVVRQH8M85c5yZe4dmBIXJBNEcRwMF+/UHiOMPetCMQHqLiCjoFz5MWD4kUhpSIDqBqA9DGYr60A8fBH0P6i2hMGPCmRwYmQydmZv3OnN82OfeM/eeS7TgcPZe67u+e+291l47Sn/WTpZhC17ARqzK9BO4jiu4ijutjlEbwpfwEZ5pu1Quv+AznF2sjFtAR3Dpf5DBJnyN44t5FhMewgeNWZT9q3iYfdUWW5C3cbSVcBcONMHmM5K1x+jbSvcGBr5ED7UC6T7shQRL8UlhQ5HgmHax7hzzM8z8RLUSvIpyGNdiDAmZbCZL8C/G3icu0bmaic+5v0BHW8I12BFjd4EMZrB0A099S9QTdAMnWDEUbGlh2/BKXIgOZvHY02y+St92apPUxik/x6bL9L8YMGnBc32MlU3RVZH0MXiKJDPd+47p0xmok8Fv6F1HpRBlX9xQRdmKD7DmQ0rP5rCpUW5/pVE3UYknR4jiQsZj3G6MZtG/jceHc8Tds9z5kX/GGN+f63u3sfpASFwu92JcFwnh925kYDQ3V//gxnskKT0YG+H+tdy+8iBP7GGuEeXvMb4XCUVcXkuyIkM/4OabVKbpRlem+20vtVs5afl5Fhqz8x0fv2FSarcllpv9k+o4pUGmzjBxmnJ2HGnIh7kK81OUBzLMp3TV4C8M17vNyyIXLAiHnJRZmAtEHfLyqCeuho4SDyvBniD1Kkbrd/mi1BeiLIp0LgBjzbVWHyfCoXc2FjyJUZq7zTBOkIGKtyCXqMnzDN6tTxYTzuMdvIZf/4OuLjfxFl6XN7a2HRv6sVO45+uFJwH+xg38gMuYbHV8BE2vqqJahaobAAAAAElFTkSuQmCC
""")

def main():
    brewery_cached = cache.get("brewery")
    beer_cached = cache.get("beer")
    number_of_beers_cached = cache.get("number_of_beers")
    if beer_cached != None:
        print("Hit! Beer is cached and serving cached data.")
        brewery = brewery_cached
        beer = beer_cached
    else:
        print("Miss! Beer is not cached. Calling Untappd API")
        user_feed = http.get(UNTAPPD_USER_FEED)
        if user_feed.status_code != 200:
            return render.Root(
                render.Row(
                    children=[
                        render.Box(
                            width=28, 
                            height=32,
                            child=render.Image(src=UNTAPPD_LOGO),
                        ),
                        render.Box(
                            width=36,
                            height=32,
                            child=render.WrappedText(
                                content="API ERROR",
                                color="#f00",
                            )
                        )
                    ]
                )
            )
        brewery = user_feed.json()["response"]["checkins"]["items"][0]["brewery"]["brewery_name"]
        beer = user_feed.json()["response"]["checkins"]["items"][0]["beer"]["beer_name"]
        cache.set(KEY_BREWERY, brewery, ttl_seconds=300)
        cache.set(KEY_BEER, beer, ttl_seconds=300)

    if number_of_beers_cached != None:
        print("Hit! Number of beers is cached and serving cached data.")
        number_of_beers = number_of_beers_cached
    else:
        print("Miss! Number of beers is not cached. Calling Untappd API")
        user_info = http.get(UNTAPPD_USER_INFO)
        if user_info.status_code != 200:
            return render.Root(
                render.Row(
                    children=[
                        render.Box(
                            width=28, 
                            height=32,
                            child=render.Image(src=UNTAPPD_LOGO),
                        ),
                        render.Box(
                            width=36,
                            height=32,
                            child=render.WrappedText(
                                content="API ERROR",
                                color="#f00",
                            )
                        )
                    ]
                )
            )
        number_of_beers = user_info.json()["response"]["user"]["stats"]["total_beers"]
        number_of_beers = str(int(number_of_beers))
        cache.set(KEY_NUMBER_OF_BEERS, str(number_of_beers), ttl_seconds=300)
    
    return render.Root(
        render.Row(
           children=[
               render.Box(
                   width=28, 
                   height=32,
                   child=render.Image(src=UNTAPPD_LOGO),
                ),
                render.Box(
                    width=36,
                    height=32,
                    child=render.Column(
                        children = [
                            render.Marquee(
                                width=36,
                                height=8,
                                child=render.Text(brewery + ": " + beer)
                            ),
                            render.Text("#" + number_of_beers)
                        ]
                    )
                )
           ]
        )
    )