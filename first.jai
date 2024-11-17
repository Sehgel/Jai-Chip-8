BASE_WIDTH    :: 64;
BASE_HEIGHT   :: 32;

WINDOW_WIDTH  :: BASE_WIDTH * 18;
WINDOW_HEIGHT :: BASE_HEIGHT * 18;

PIXEL_SIZE :: WINDOW_HEIGHT / 8;
window : Window_Type;

key_left  : u32;
key_right : u32;
key_up    : u32;
key_down  : u32;

position := Vector2.{0.0,0.0};

main :: () {
    window := create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Chip-8 Emulator");
    Simp.set_render_target(window, .LEFT_HANDED);

    quit := false;
    while main := !quit {
        Input.update_window_events();

        for Input.events_this_frame {
            if it.type == .QUIT then break main;

            if it.type == .KEYBOARD {
                if it.key_code == .ESCAPE then break main;
            }
            process_input(it);
            process_logic();
        }


        render_stuff();
        Simp.swap_buffers(window);
    }
    reset_temporary_storage();
}

process_input :: (event : Input.Event) {
    if event.type == .KEYBOARD {
        if event.key_code == .ARROW_LEFT  key_left  = event.key_pressed;
        if event.key_code == .ARROW_RIGHT key_right = event.key_pressed;
        if event.key_code == .ARROW_DOWN  key_down  = event.key_pressed;
        if event.key_code == .ARROW_UP    key_up    = event.key_pressed;
    }
}
process_logic :: () {
    if key_left  position.x -= PIXEL_SIZE;
    if key_right position.x += PIXEL_SIZE;
    if key_down  position.y += PIXEL_SIZE;
    if key_up    position.y -= PIXEL_SIZE;
}
render_stuff :: () {
    Simp.clear_render_target(0,0,0,1);
    //Simp.immediate_begin();
    Simp.set_shader_for_color();
    draw_rect(position,.{1,1,1,1});
    //Simp.immediate_flush();
}

draw_rect :: (pos : Vector2, color : Vector4) {
    Simp.immediate_quad(pos.x,pos.y, pos.x+PIXEL_SIZE, pos.y+PIXEL_SIZE, color);
}

#import "Basic";
#import "Math";
#import "Window_Creation";
Input :: #import "Input";
Simp :: #import "Simp";