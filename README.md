# Tidbyt Untappd

Tidbyt Untappd is an applet developed for [Tidbyt](https://tidbyt.com), using Pixlet, an app runtime and UX toolkit and the Untappd API. The applet shows the Untappd logo, along with the last beer the specified user has checked into and the tally of unique beers that user has tried.

Apps developed with Pixlet can be served in a browser, rendered as WebP or
GIF animations, or pushed to a physical Tidbyt device.

<img src="docs/img/untappd.gif" alt="tidbytuntappd" width="360" />
Example image blown up from 64x32

## Getting started

### Install on macOS

```
brew install tidbyt/tidbyt/pixlet
```

### Install on Linux

Download the `pixlet` binary from [the latest release][1].

Alternatively you can [build from source](BUILD.md).

[1]: https://github.com/tidbyt/pixlet/releases/latest

## How it works

Pixlet scripts are written in a simple, Python-like language called
[Starlark](https://github.com/google/starlark-go/). The scripts can
retrieve data over HTTP, transform it and use a collection of
_Widgets_ to describe how the data should be presented visually.

The Pixlet CLI runs these scripts and renders the result as a WebP
or GIF animation. You can view the animation in your browser, save
it, or even push it to a Tidbyt device with `pixlet push`.

# Preparing Tidbyt Untappd for use

Open the untappd.star file and add your Untappd Client ID and Untappd Secret ID from your Untappd API dashboard designated in the file in `UNTAPPD_CLIENT_ID` and `UNTAPPD_SECRET_ID`.

Update the Untappd username in the designated variable `UNTAPPD USER`

Test within a local browser by running:

```
pixlet serve dist/untappd.star
```

Navigate to http://localhost:8080 to verify the app is running without issue.

## Push to a Tidbyt

If you have a Tidbyt, `pixlet` can push apps directly to it. For example,
to show the Bitcoin tracker on your Tidbyt:

```
pixlet render examples/bitcoin.star
pixlet push --api-token <YOUR API TOKEN> <YOUR DEVICE ID> examples/bitcoin.webp
```

To get the ID and API key for a device, open the settings for the device in the Tidbyt app on your phone, and tap **Get API key**.

If all goes well, you should see the Bitcoin tracker appear on your Tidbyt:

![](doc/img/tidbyt_2.jpg)
