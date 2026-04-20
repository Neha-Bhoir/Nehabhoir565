# Funnel Pages

Static funnel implementation for:
- Landing page
- Checkout page
- Upsell page
- Downsell page
- Thank you page

## Start preview (background)

From repository root:

```bash
./preview.sh
```

Then open:
- `http://127.0.0.1:4173/`

> If you see **"This site can’t be reached"**, it means the preview server is not running yet. Start it with `./preview.sh` first.

## Stop preview

```bash
./preview.sh --stop
```

## Manual preview (foreground)

```bash
cd funnel
python3 -m http.server 4173 --bind 0.0.0.0
```

Then open `http://127.0.0.1:4173/`.

## Direct pages
- Landing: `http://127.0.0.1:4173/index.html`
- Checkout: `http://127.0.0.1:4173/checkout.html`
- Upsell: `http://127.0.0.1:4173/upsell.html`
- Downsell: `http://127.0.0.1:4173/downsell.html`
- Thank you: `http://127.0.0.1:4173/thankyou.html`
