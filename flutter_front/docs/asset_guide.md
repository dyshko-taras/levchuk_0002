# Asset management rules

Rules for managing static assets (images, fonts, icons) in Flutter apps. Apply these rules whenever assets are added, replaced, or audited.

## Images

### Format

1. Use **WebP** instead of PNG for all raster images. WebP provides 25–35% smaller files at equivalent quality. Convert existing PNGs with: `cwebp -q 80 input.png -o output.webp`.
2. **JPEG** is acceptable for photographic content where WebP is not practical. Strip metadata and optimize all JPEGs before committing:
   ```
   mogrify -strip -interlace Plane -sampling-factor 4:2:0 -quality 80 -define jpeg:extent=3MB *.jpg
   ```
3. **Avoid re-compressing already-optimized JPEGs.** Re-encoding a lossy JPEG degrades quality with each pass. Before running `mogrify`, check whether stripping/optimization is actually needed:
   - Run `identify -verbose <file> | grep -i 'exif\|profile'` — if no EXIF/ICC profiles are found, the file is already stripped.
   - Check file size against the 500 KB limit — if already under, skip re-encoding.
   - Only run the full `mogrify` command on files that are either unstripped (contain metadata) or exceed the size limit.
4. Never commit raw/unoptimized images from cameras, stock sites, or design tools — they often contain megabytes of EXIF data and use uncompressed color profiles.

### Size limits

5. No single image file may exceed **500 KB**. If an optimized image still exceeds this limit, reduce its dimensions or quality until it fits.
6. Before adding an image, check its dimensions against the largest container it will appear in (accounting for 3x pixel density). An image displayed at 200×200 logical pixels needs at most 600×600 physical pixels — anything larger wastes bundle size.
7. **Resize oversized images.** After determining the maximum needed dimensions (logical size × 3), downscale any image that exceeds them. Use ImageMagick to resize while preserving aspect ratio and re-encode to WebP:
   ```
   magick input.webp -resize {max_width}x{max_height} -define webp:quality=80 output.webp
   ```
   Common reference sizes (logical → max physical at 3x):
   - Small icon/thumbnail (40–56 px): 120–168 px
   - Card banner (350×140 px): 1050×420 px
   - Full-screen background (390×844 px): 1170×2532 px

   To audit all images in a directory at once:
   ```
   for f in *.webp; do
     dims=$(magick identify -format '%wx%h' "$f")
     size=$(du -h "$f" | cut -f1)
     echo "$f: $dims ($size)"
   done
   ```
   Compare each image's dimensions against its display container and resize any that exceed the 3x limit.

### Naming

8. Use **snake_case** for all image filenames (e.g. `hero_banner.jpg`, not `hero-banner.jpg` or `HeroBanner.jpg`). This matches Dart naming conventions and avoids platform-specific filesystem issues.
9. Organize images into subdirectories by purpose (e.g. `assets/images/photos/`, `assets/images/icons/`, `assets/images/backgrounds/`).

### Cleanup

10. Delete unused images. Before each release or major commit, cross-reference asset files against code references (`Image.asset` calls, `AssetImage` constructors, image key/path constants). Remove any file not referenced.
11. Delete duplicate images. If the same image exists under multiple names or naming conventions, keep only the one referenced in code.

## Fonts

### Variable fonts

1. Prefer **variable fonts** over multiple static font files. A single variable font file covers all weights (and optionally widths/italics) at a smaller total size than individual Regular/Medium/Bold/etc. files.
2. Download variable fonts from [Google Fonts](https://fonts.google.com) or the [google/fonts GitHub repository](https://github.com/google/fonts). Variable font files are named with `[axis]` suffixes (e.g. `Montserrat[wght].ttf`).

### Cleanup

3. Delete unused font files. Check which font weights and styles are actually used in the codebase (`FontWeight`, `FontStyle.italic`). If no italic styles exist, do not ship an italic font file.
4. Delete static font files when a variable font is available and registered. Do not keep both.

### Registration

5. Always register fonts in `pubspec.yaml` under the `fonts:` section with an explicit `family` name. Do not rely on the generic `assets:` directory listing — Flutter needs the `fonts:` declaration to map family names correctly.
   ```yaml
   fonts:
   - family: FontFamilyName
     fonts:
     - asset: assets/fonts/FontFamilyName-VariableFont_wght.ttf
   ```

## Icons

1. Prefer **Material Icons** (`Icons.*`) or a single icon font over individual icon image files. Icon fonts scale without quality loss and add zero per-icon bundle cost.
2. If custom icon images are necessary, use **SVG** rendered via `flutter_svg`, or export as WebP at the required sizes.
3. App launcher icons should follow platform guidelines for dimensions and safe zones. Use `flutter_launcher_icons` to generate platform-specific variants from a single source image.

## General

1. Register every asset directory in `pubspec.yaml` under `assets:`. Unregistered directories are not bundled.
2. Do not register asset directories that do not exist — Flutter will warn during builds.
3. Run `flutter analyze` after any asset changes to catch registration or path issues.
