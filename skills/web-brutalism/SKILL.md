---
name: web-brutalism
description: >
  Web brutalism design guide: how to build UIs using browser-native default styles. Use this skill
  whenever the user is designing or building a new web page, UI component, browser extension popup,
  settings panel, or any frontend interface — especially when they want a minimal, functional, or
  "native" aesthetic. Also trigger when the user mentions brutalism, "browser defaults", "no custom
  styles", "native HTML", Swiss International style, or wants to avoid over-styling. Covers
  philosophy, design brief, style presets, HTML element selection, and acceptable CSS overrides.
---

## Philosophy

Brutalism in architecture means materials are left in their raw state — concrete is concrete, steel
is steel. In web design: **let the browser's native rendering be the default, and only override
what serves a functional purpose.**

The browser already has a complete visual language: heading hierarchy, form controls that match the
OS, interactive states, accessible defaults, and automatic adaptation to system preferences (dark
mode, font size, contrast). Overriding these is work that must pay for itself.

**Spacing and alignment are the primary design tools.** When color, custom fonts, and decoration
are removed, spacing and alignment carry all expressive weight: they signal focus, hierarchy, and
tone. They are functional, not decorative.

- **Alignment signals level**: elements sharing an alignment are read as peers. An element indented
  relative to its neighbours is read as subordinate. Hierarchy is expressed horizontally;
  vertical proximity signals grouping.
- **Spacing signals focus**: an element with more surrounding space than its neighbours reads as
  more important. Titles have more breathing room than paragraphs for this reason.
- **Spacing density sets tone**: tight spacing reads as formal and efficient; loose spacing reads as
  relaxed and editorial. Extreme contrasts — very large headings against tight body, wide margins
  against dense type — read as bold and modern.

The principle: **if a property override is purely decorative, remove it.**

## CSS Overrides: What Is and Isn't Allowed

**Allowed — functional:**

- Spacing: `margin`, `padding`, `gap`
- Layout: `display: flex/grid`, `flex-direction`, `align-items`, `justify-content`, `grid-template-*`
- Sizing: `width`, `max-width`, `min-width`, `max-height`, `flex: 1`, `flex-shrink`
- Typography: `letter-spacing` and `line-height` on headings to refine typographic rhythm; on
  body text to improve readability (WCAG 1.4.12 requires content to remain readable at 1.5× line
  height; browser defaults around 1.2 are below this — setting `line-height: 1.5` on body is
  recommended); `font-size: inherit` on `input`, `button`, `select`, `textarea` removes browser
  inconsistencies so co-located controls align to the same size; `font-family` using system font
  stacks — selecting among fonts already installed on the OS imposes no download cost and respects
  the spirit of native materials; use stacks from [modern-font-stacks.md](modern-font-stacks.md),
  chosen to match the style preset and typographic voice established in the design brief
- Utility: `box-sizing: border-box`, `cursor: pointer`, `overflow`, `white-space`

**Not allowed — decorative or costly:**

- `color`, `background-color` with custom values — breaks dark mode, high-contrast mode,
  accessibility preferences; CSS system color keywords (`CanvasText`, `Canvas`, `LinkText`,
  `GrayText`, `ButtonText`, etc.) are allowed, as they adapt automatically with `color-scheme`
- `border-color`, `border-radius` — decorative
- Web fonts (`@font-face`, Google Fonts, Typekit, etc.) — download cost and foreign aesthetic;
  system font stacks are the alternative
- `font-size` on semantic elements (`h1`–`h6`, `p`, `small`, etc.) — destroys the browser's scale
- `font-weight` on body/paragraph elements — exception: `<label>` elements may use `font-weight`
  to visually differentiate labels from input values in form UI chrome
- `text-transform` on body/paragraph elements
- `:focus { outline: none }` — removes focus rings for keyboard users; if suppressing mouse-click
  rings is needed, use `:focus:not(:focus-visible) { outline: none }` instead; modern browsers
  already apply focus rings via `:focus-visible` semantics by default

Use relative units (`em`, `lh`, `ch`, `rem`) for spacing rather than `px`. Relative units keep
spacing proportional to typography and scale naturally with user font-size preferences. Absolute
units (`px`) are appropriate only for borders and shadows where physical precision matters.
Build bottom-up: typographic elements define their own spacing, UI components compose from those,
page layout composes from components. A consistent grid emerges naturally from this rather than
being imposed top-down.

## The Minimal CSS Baseline

```css
:root {
  color-scheme: light dark;
}

*,
*::before,
*::after {
  box-sizing: border-box;
}

input,
button,
select,
textarea {
  font-size: inherit;
}
```

`color-scheme: light dark` is essential — it renders all native controls (buttons, inputs,
scrollbars, system colors like `Canvas`, `CanvasText`, `GrayText`) in the user's preferred scheme.

Do **not** add a CSS reset. Resets erase browser defaults and force you to rebuild everything.

## Start with a Design Brief

Before writing any CSS, establish three things:

1. **What is the page for?** (settings panel, editorial article, dashboard, landing page, form)
2. **What should it feel like?** (formal/professional, relaxed/editorial, bold/modern, dense/technical)
3. **What is the typographic voice?** — pick from the style preset's recommended font stacks;
   context matters: a fashion editorial and a news editorial are both "Editorial" preset but call
   for different voices (geometric/industrial vs. transitional serif)

The feel and voice together determine spacing density, heading contrast, and font stack choice.
Use the style presets below as named starting points.

## Style Presets

Each preset describes spacing density, alignment approach, and font-spacing stance. Implementation
units are project-specific; treat these as calibration profiles, not pixel recipes.

### Swiss International

Grid-governed, flush-left, generous whitespace, strong typographic hierarchy. The closest
philosophical cousin to brutalism — both prioritise rational structure over decoration.

- Spacing: medium-generous; heading top-margin significantly larger than bottom-margin
- Alignment: strict flush-left; grid columns respected across all elements
- Font spacing: headings slightly tracked out (`letter-spacing: 0.02–0.05em`); body untouched
- Elements: favour `section`/`header`/`nav` structure; `dl` for metadata
- Font stacks: **Neo-Grotesque** (primary, e.g. Helvetica/Inter), Geometric Humanist (Futura/Avenir)
- Feel: authoritative, rational, clean

### Bauhaus / Functionalist

Geometric, structured, form-follows-function. Uses visible native structure (fieldset borders,
table lines, `hr`) as design elements rather than hiding them.

- Spacing: tight-to-medium; structural elements (`fieldset`, `table`, `hr`) carry visual weight
- Alignment: grid-governed, geometric grouping
- Font spacing: uppercase headings with compensating `letter-spacing`; body untouched
- Elements: `fieldset`/`legend`, `table`, `dl`, `hr` as primary structural vocabulary
- Font stacks: **Industrial** (primary, e.g. Bahnschrift/Franklin Gothic), Geometric Humanist
  (Futura), Slab Serif (Rockwell — block serifs fit the geometric vocabulary)
- Feel: industrial, purposeful, structured

### Editorial / Magazine

Varied rhythm, pull quotes, captions, dynamic section contrast. The spacing variation is the
design — a large gap before a section heading and a tight gap after it creates visual pull.

- Spacing: variable; large gaps between sections, tight internal to sections
- Alignment: mixed — body flush-left, `blockquote`/`figure` with distinct margin treatment
- Font spacing: headings may use `letter-spacing` and adjusted `line-height` for rhythm
- Elements: `blockquote`, `figure`/`figcaption`, `aside`, `details` for sidebars
- Font stacks: **Transitional or Old Style** (news/literary — Charter, Garamond), **Didone**
  (fashion/luxury — Didot, Bodoni), **Neo-Grotesque or Industrial** (modern/utility editorial),
  Humanist (warm/personal) — let the subject matter decide
- Feel: dynamic, journalistic, considered

### Technical / Documentation

Dense, precise, monospace-forward. Native code and data elements are first-class.

- Spacing: tight; minimal vertical gaps, strong horizontal alignment
- Alignment: strict; code blocks, tables, and `dl` all share a left edge
- Font spacing: none; body and code elements left fully native
- Elements: `code`, `pre`, `kbd`, `samp`, `var`, `table`, `dl`, `details`/`summary` for collapsible sections
- Font stacks: **Monospace Code** (primary, e.g. ui-monospace/Cascadia Code), Monospace Slab Serif
  (Courier — typewriter feel for reports and tabular output)
- Feel: precise, information-dense, developer-native

### Minimalist

Maximum whitespace, restrained hierarchy, near-invisible structure. The generous spacing IS the
design; every element needs a reason to exist.

- Spacing: large — use 2–3× typical gaps; let content breathe
- Alignment: consistent and quiet; no element competes for attention
- Font spacing: none or very subtle; let the browser scale speak
- Elements: minimal; remove anything not earning its place
- Font stacks: **System UI** (primary — highest legibility, lowest visual noise), Humanist,
  Classical Humanist (Optima/Candara — subtle stroke variation without serifs, very quiet)
- Feel: calm, considered, spacious

---

**Styles that push against the constraints** (achievable with caveats):

**Avant-garde / Constructivism** — extreme spacing contrasts and unusual alignment work, but the
style relies on color contrast and diagonal tension that can't be expressed without color overrides.

**New Wave Typography** — variable `letter-spacing` on headings (now permitted) can gesture toward
this, but the style needs font variation (multiple weights, mixed families) to fully land.

**Postmodern** — intentional hierarchy subversion is possible with element choice and spacing
irony, but needs multiple typographic voices (font-family variation) to fully read as postmodern.

## HTML Elements as Functional Tools

Full reference: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements

Before reaching for `<div>` + JavaScript, check if a native element already does the job.

### Interactive without JavaScript

| Element                                   | Native behaviour                                                      |
| ----------------------------------------- | --------------------------------------------------------------------- |
| `<details>` / `<summary>`                 | Collapsible disclosure — no JS accordion needed                       |
| `<dialog>`                                | Modal — `dialog.showModal()` handles focus trap, backdrop, Escape key |
| `<input type="range">`                    | Slider with min/max/step                                              |
| `<input type="color">`                    | OS color picker                                                       |
| `<input type="date/time/datetime-local">` | OS date/time picker                                                   |
| `<select>` / `<datalist>`                 | Dropdown or autocomplete                                              |
| `<progress>` / `<meter>`                  | Progress bar and value gauge                                          |

### Form structure

`<fieldset>` + `<legend>` groups related controls with semantic grouping, visual grouping, and
accessibility announcement — zero CSS needed.

`<label>` wrapping its control (rather than `for`/`id`) makes the entire label area a click target.

When `<input>` and `<button>` are used together, apply `font-size: inherit` (included in the
baseline) so browser inconsistencies don't produce mismatched heights.

### Typography

`<h1>`–`<h6>` already define a meaningful scale. `<strong>`, `<em>`, `<code>`, `<kbd>`, `<samp>`,
`<var>`, `<blockquote>`, `<small>` all have native rendering. Use them; don't rebuild them.

`<dl>` / `<dt>` / `<dd>` is underused. It's the right element for key-value pairs, settings rows,
metadata, glossaries — no table or custom layout component needed.

### Sectioning

`<section>`, `<article>`, `<nav>`, `<aside>`, `<header>`, `<footer>`, `<main>` carry semantic
meaning for assistive technology. Use them over `<div>`. They have no visual effect by default;
add only the spacing needed.

### Media

`<figure>` + `<figcaption>` gives semantically captioned media with native indented block style.
`<picture>` with `srcset` handles responsive images without JS.

## Building a Settings Panel

```html
<form>
  <fieldset>
    <legend>Display</legend>
    <label><input type="checkbox" name="darkMode" /> Dark mode</label>
    <label>
      Columns
      <input type="range" name="columns" min="1" max="4" value="2" />
    </label>
    <label>
      Theme
      <select name="theme">
        <option>System</option>
        <option>Light</option>
        <option>Dark</option>
      </select>
    </label>
  </fieldset>

  <details>
    <summary>Advanced</summary>
    <fieldset>
      <legend>Developer</legend>
      <label><input type="checkbox" name="debug" /> Debug mode</label>
    </fieldset>
  </details>

  <button type="submit">Save</button>
</form>
```

Only spacing CSS needed. No custom component library.

## Accessibility Foundation

Native HTML elements carry built-in accessibility support that custom components must rebuild from
scratch: focus management, keyboard navigation, screen reader semantics, and system color
adaptation via `color-scheme`. This is a head start, not a guarantee.

- Focus styles: provided by the browser via `:focus-visible` — keyboard users see the ring, mouse
  users don't; do not add `:focus { outline: none }`
- Color adaptation: `color-scheme: light dark` makes system color keywords adapt automatically
- Screen reader semantics: `<fieldset>`, `<label>`, `<button>`, `<details>` are already understood
- Keyboard navigation: works without JavaScript for native interactive elements

Per-project requirements (touch target sizes, `lang` attribute, `aria-*` for dynamic state,
WCAG conformance level) must be confirmed during implementation — this guide doesn't cover them.

## Applying This Skill

When designing a new page:

1. Establish the design brief — purpose and feel
2. Pick a style preset as a calibration starting point
3. Identify the function of each UI piece; find the native element that does it
4. Write semantic HTML with minimal nesting
5. Add spacing CSS to express focus, hierarchy, and tone
6. Stop — if a property is purely visual, it doesn't belong

When reviewing existing UI, flag:

- Custom `font-family`, `font-size` overrides on semantic elements
- `color`/`background-color` not using system color keywords
- `border-radius`, `text-transform`, `font-weight` on body elements (decorative)
- CSS resets (normalize.css, reset.css)
- JavaScript used where a native element would suffice
