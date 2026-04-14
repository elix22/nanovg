// NanoVG implementation for Sokol.NET
//
// This file wraps nanovg.c to resolve duplicate-symbol conflicts that arise
// when nanovg is built alongside sokol.c:
//
//  * fons* (fontstash) functions: sokol.c AND nanovg each compile their own
//    fontstash with incompatible APIs (different fonsAddFontMem signatures etc.).
//    All 28 public fons* symbols are renamed to nvg_fons* via the #defines
//    below so that nanovg's fontstash lives in its own symbol namespace.
//    nanovg.c calls these renamed symbols; sokol.c's fons* are unaffected.
//
//  * stbtt_* (stb_truetype) functions: all declared `static` inside
//    stb_truetype.h, so having them in two separate .o files is fine.
//
//  * stbi_* (stb_image) functions: sokol.c compiles the full STB-image
//    implementation.  NVG_NO_STB_IMAGE_IMPLEMENTATION tells nanovg.c to
//    #include stb_image.h for declarations only; calls link to sokol.o.

// --- Rename all public fons* symbols → nvg_fons* --------------------------
// This prevents duplicate-symbol linker errors against sokol.c's fontstash.
#define fonsCreateInternal    nvg_fonsCreateInternal
#define fonsDeleteInternal    nvg_fonsDeleteInternal
#define fonsSetErrorCallback  nvg_fonsSetErrorCallback
#define fonsGetAtlasSize      nvg_fonsGetAtlasSize
#define fonsExpandAtlas       nvg_fonsExpandAtlas
#define fonsResetAtlas        nvg_fonsResetAtlas
#define fonsAddFont           nvg_fonsAddFont
#define fonsAddFontMem        nvg_fonsAddFontMem
#define fonsGetFontByName     nvg_fonsGetFontByName
#define fonsAddFallbackFont   nvg_fonsAddFallbackFont
#define fonsResetFallbackFont nvg_fonsResetFallbackFont
#define fonsPushState         nvg_fonsPushState
#define fonsPopState          nvg_fonsPopState
#define fonsClearState        nvg_fonsClearState
#define fonsSetSize           nvg_fonsSetSize
#define fonsSetColor          nvg_fonsSetColor
#define fonsSetSpacing        nvg_fonsSetSpacing
#define fonsSetBlur           nvg_fonsSetBlur
#define fonsSetAlign          nvg_fonsSetAlign
#define fonsSetFont           nvg_fonsSetFont
#define fonsDrawText          nvg_fonsDrawText
#define fonsTextBounds        nvg_fonsTextBounds
#define fonsLineBounds        nvg_fonsLineBounds
#define fonsVertMetrics       nvg_fonsVertMetrics
#define fonsTextIterInit      nvg_fonsTextIterInit
#define fonsTextIterNext      nvg_fonsTextIterNext
#define fonsGetTextureData    nvg_fonsGetTextureData
#define fonsValidateTexture   nvg_fonsValidateTexture
#define fonsDrawDebug         nvg_fonsDrawDebug
// --------------------------------------------------------------------------

// Use stb_image declarations only; implementation lives in sokol.c / sokol.o
#define NVG_NO_STB_IMAGE_IMPLEMENTATION

// Pull in the full nanovg implementation (nanovg.c, fontstash, stb_truetype)
#include "nanovg.c"
