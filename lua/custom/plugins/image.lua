-- Inline image rendering via Kitty's graphics protocol (Ghostty speaks it too).
-- Renders images in markdown buffers, and shows image files as images when opened.
-- Needs: `brew install imagemagick`, and tmux `allow-passthrough on` (see tmux.conf).
return {
  '3rd/image.nvim',
  build = false, -- don't try to build the magick luarock; we use the CLI processor
  lazy = false, -- must be loaded to hijack `nvim foo.png`
  opts = {
    backend = 'kitty',
    processor = 'magick_cli', -- shells out to `magick`; no luarock needed
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = true,
        only_render_image_at_cursor = false,
      },
    },
    max_width_window_percentage = 80,
    max_height_window_percentage = 50,
    -- Floats (telescope, neominimap, which-key) draw over images, which the
    -- terminal doesn't know about -- clear them while something overlaps.
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
    -- Needs `set -g visual-activity off` in tmux.conf to work correctly.
    tmux_show_only_in_active_window = true,
    -- No '*.gif': an animated GIF is the largest payload to push through tmux
    -- passthrough, and tmux forwards it blind. Open those outside nvim.
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.webp', '*.avif' },
  },
}
