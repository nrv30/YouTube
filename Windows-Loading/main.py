from pyray import *
from dataclasses import dataclass
import math

@dataclass
class Timer:
    max_time: float
    time_elapsed: float = 0

    def update_timer(self, dt):
        if self.time_elapsed + dt < self.max_time:
            self.time_elapsed += dt
            return True
        else:
            self.time_elapsed = 0
            return False

    def get_percent(self):
        return self.time_elapsed / self.max_time

@dataclass
class Circle:
    timer: Timer
    radius: int = 0
    x: int = 0
    y: int = 0
    angle: float = 0

    def d_theta(self):
        t = clamp(math.sqrt(self.timer.get_percent()), 0, 1)
        return (start_angle - lerp(0, tau, t))

    def angle_to_circ_point(self):
        return (int(origin.x + pattern_radius * math.cos(self.angle)), int(origin.y - pattern_radius * math.sin(self.angle)))

    def update(self, dt):
        self.angle = self.d_theta()
        self.x, self.y = self.angle_to_circ_point()
        self.timer.update_timer(dt)

if __name__ == "__main__":

    width = 16*60
    height = 9*60
    origin = Vector2(width // 2, height//3)
    tau = 2*math.pi
    start_angle = math.pi/2
    pattern_radius = 100
    background_color = (1, 100, 182)

    circ_color = (225, 255, 255, 255)
    circ_radius = 3

    circles = []
    circles.append(Circle(Timer(3, 0), circ_radius))

    circs_timer = Timer(4/60, 0)
    anim_timer = Timer(10, 0)
    should_close = False
    started = False

    fps = 24
    dt = 1/fps
    set_target_fps(fps)
    init_window(width, height, 'loading')
    init_audio_device()

    update_sound = load_sound('sound.wav')

    while(not window_should_close() and (not should_close or is_sound_playing(update_sound))):

        if started:
            if not anim_timer.update_timer(dt):
                play_sound(update_sound)
                should_close = True

            # update
            for circle in circles:
                circle.update(dt)

            if not circs_timer.update_timer(dt):
                if len(circles) < 5:
                    circles.append(Circle(Timer(3, 0), circ_radius)) 
        else:
            if (is_key_pressed(KeyboardKey.KEY_SPACE)):
                started = True

        begin_drawing()

        clear_background(background_color)
        for circle in circles:
            draw_circle(circle.x, circle.y, int(circle.radius), circ_color)
        if started:
            progress =  int(anim_timer.get_percent()*100) if not should_close else 100
            message = f'configuring windows updates\n \t\t\t{progress}% complete\nDon\'t turn off computer'
            draw_text(message, int(origin.x - measure_text(message, 14)/2), int(origin.y + 150 - 20), 14, RAYWHITE)

        end_drawing()

    unload_sound(update_sound)
    close_audio_device()
    close_window()