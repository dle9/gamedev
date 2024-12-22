import pygame, sys, random
from pygame.locals import *

# ======================================================
# ====================== SETTINGS ======================
# ======================================================
SPRITE_WIDTH = 50
SPRITE_HEIGHT = 100
SCREEN_WIDTH = 1900
SCREEN_HEIGHT = 900
FPS = 60

PRIM_COLOR = (80, 107, 127)  # nordic
SEC_COLOR = (226, 153, 140)  # pink eye
BG_COLOR = (40, 44, 53)      # ebony night
HL1_COLOR = (241, 222, 123)  # sunny
HL2_COLOR = (93, 102, 88)    # ebony forest
WHITE = (255, 255, 255)

# Define key mapping
KEY_MAPPING = {
    # Easy
    ".": pygame.K_PERIOD,
    ",": pygame.K_COMMA,
    "'": pygame.K_QUOTE,
    "\"": pygame.K_QUOTEDBL,
    "/": pygame.K_SLASH,
    ":": pygame.K_COLON,
    ";": pygame.K_SEMICOLON,
    "-": pygame.K_MINUS,
    "_": pygame.K_UNDERSCORE,

    # Medium
    "(": pygame.K_LEFTPAREN,
    ")": pygame.K_RIGHTPAREN,
    "#": pygame.K_HASH,
    "<": pygame.K_LESS,
    ">": pygame.K_GREATER,
    "[": pygame.K_LEFTBRACKET,
    "]": pygame.K_RIGHTBRACKET,
    "\\": pygame.K_BACKSLASH,

    # Hard
    "!": pygame.K_EXCLAIM,
    "$": pygame.K_DOLLAR,
    "?": pygame.K_SLASH,
    "%": pygame.K_PERCENT,
    "&": pygame.K_AMPERSAND,
    "*": pygame.K_ASTERISK
}

SHIFT_CHARS = {
    "\"",  # Shift + '
    ":",   # Shift + ;
    "_",   # Shift + -
    "(",   # Shift + 9
    ")",   # Shift + 0
    "#",   # Shift + 3
    "<",   # Shift + ,
    ">",   # Shift + .
    "!",   # Shift + 1
    "$",   # Shift + 4
    "?",   # Shift + /
    "%",   # Shift + 5
    "&",   # Shift + 7
    "*",   # Shift + 8
}

# ======================================================
# ======================== GAME ========================
# ======================================================
class Game:
    def __init__(self):
        self.running = True
        self.display_surf = None
        self.fps = None
        self.size = self.weight, self.height = SCREEN_WIDTH, SCREEN_HEIGHT
        self.player = Player()
        self.enemies = []
        self.difficulty = "easy"  # Can change to 'medium' or 'hard'

        # Spawn timing settings
        self.spawn_timer = 0
        self.spawn_delay = 5000
        self.last_spawn_time = pygame.time.get_ticks()
        self.max_enemies = 20
        
        # Define row options based on difficulty
        self.row_options = {
            "easy": [".", ",", "'", "\"", "/", ":", ";", "-", "_"],
            "medium": [".", ",", "'", "\"", "/", ":", ";", "-", "_", "(", ")", "#", "<", ">", "[", "]", "\\"],
            "hard": [".", ",", "'", "\"", "/", ":", ";", "-", "_", "(", ")", "#", "<", ">", "[", "]", "\\", "!", "$", "?", "%", "&", "*"]
        }

        # Generate row assignments for the player in the game (9 rows)
        self.row_assignments = self.generate_row_assignments()
        
        # Font for row indicators
        self.font = None

    def init(self):
        pygame.init()
        self.display_surf = pygame.display.set_mode(self.size, pygame.HWSURFACE | pygame.DOUBLEBUF)
        self.running = True
        self.fps = pygame.time.Clock()
        pygame.display.set_caption("My first game!")
        
        # Initialize font after pygame.init()
        self.font = pygame.font.Font(None, 36)  # None uses default system font

    # ======================== Utility Functions ========================
    def handle_event(self, event):
        if event.type == pygame.QUIT:
            self.running = False

    def spawn_enemy(self):
        current_time = pygame.time.get_ticks()
        
        # Check if it's time to spawn and we haven't reached max enemies
        if (current_time - self.last_spawn_time >= self.spawn_delay and 
            len(self.enemies) < self.max_enemies):
            self.enemies.append(Enemy())
            self.last_spawn_time = current_time
            
            # Gradually decrease spawn delay (increase difficulty)
            self.spawn_delay = max(500, self.spawn_delay - 50)  # Min 0.5 seconds between spawns

    def loop(self):
        self.player.update(self.row_assignments)
        
        # Spawn new enemies
        self.spawn_enemy()
        
        # Update existing enemies
        for e in self.enemies:
            e.update(self.player, self.enemies)
            
        # Remove enemies that are marked for deletion (optional cleanup)
        self.enemies = [e for e in self.enemies if not hasattr(e, 'should_delete')]

    def render(self):
        self.display_surf.fill(BG_COLOR)

        # Draw row indicators before entities
        for i, key in enumerate(self.row_assignments):
            # Calculate row position
            row_y = int((i + 0.5) * SPRITE_HEIGHT)
            
            # Create text surface
            text_surface = self.font.render(key, True, WHITE)
            
            # Position text in center of row, between the bars
            text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, row_y))
            
            # Draw text
            self.display_surf.blit(text_surface, text_rect)

        self.player.draw(self.display_surf)
        for e in self.enemies:
            e.draw(self.display_surf)

        pygame.display.update()
        self.fps.tick(FPS)

    def cleanup(self):
        pygame.quit()
        sys.exit()

    # Generate unique row assignments for each row in the game
    def generate_row_assignments(self):
        options = self.row_options[self.difficulty]
        random.shuffle(options)
        return options[:9]  # Choose 9 unique row options

    # =========================== Game Loop ===========================
    def run(self):
        self.init()

        while self.running:
            # handle events
            for event in pygame.event.get():
                self.handle_event(event)

            # computation
            self.loop()

            # draw to display surface
            self.render()

        self.cleanup()

# ======================================================
# ====================== ENTITIES ======================
# ======================================================
class Player(pygame.sprite.Sprite):

    def __init__(self):
        super().__init__()

        # sprite
        self.width = SPRITE_WIDTH
        self.height = SPRITE_HEIGHT
        self.image = pygame.Surface((self.width, self.height))
        self.image.fill(PRIM_COLOR)
        self.direction = "left"

        # starting position
        self.rect = self.image.get_rect()
        self.rect.center = (SCREEN_WIDTH // 2, SCREEN_HEIGHT - 50)
        self.current_row = None

        # Left Bar
        self.leftw = SPRITE_WIDTH
        self.lefth = SCREEN_HEIGHT
        self.leftimg = pygame.Surface((self.leftw, self.lefth))
        self.leftimg.fill(HL2_COLOR)
        self.leftr = self.leftimg.get_rect()
        self.leftr.center = (SCREEN_WIDTH // 2 - SPRITE_WIDTH, SCREEN_HEIGHT // 2)

        # Right Bar
        self.rightw = SPRITE_WIDTH
        self.righth = SCREEN_HEIGHT
        self.rightimg = pygame.Surface((self.rightw, self.righth))
        self.rightimg.fill(HL2_COLOR)
        self.rightr = self.rightimg.get_rect()
        self.rightr.center = (SCREEN_WIDTH // 2 + SPRITE_WIDTH, SCREEN_HEIGHT // 2)

        # Border around the player
        self.border_thickness = 1
        self.border_color = WHITE
        self.player_border = pygame.Rect(self.rect.x - self.border_thickness, self.rect.y - self.border_thickness, self.rect.width + 2 * self.border_thickness, self.rect.height + 2 * self.border_thickness)

    def update(self, row_assignments):
        pressed_keys = pygame.key.get_pressed()

        # Dynamically assign keys based on row assignments
        row_keys = []
        
        # Map each row assignment to a key dynamically
        for i, option in enumerate(row_assignments):
            row_keys.append(KEY_MAPPING[option])

        # Check for the key press and move the player to the corresponding row
        for i, row_key in enumerate(row_keys):
            if pressed_keys[row_key]:
                self.rect.center = (SCREEN_WIDTH // 2, int((i + 0.5) * SPRITE_HEIGHT))
                self.current_row = row_key
                break

    def draw(self, surface):
        # Update border position to follow the player
        self.player_border.x = self.rect.x - self.border_thickness
        self.player_border.y = self.rect.y - self.border_thickness
        
        surface.blit(self.image, self.rect)
        surface.blit(self.leftimg, self.leftr)
        surface.blit(self.rightimg, self.rightr)
        pygame.draw.rect(surface, self.border_color, self.player_border, self.border_thickness)

class Enemy(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()

        # sprite
        self.width = SPRITE_WIDTH
        self.height = SPRITE_HEIGHT
        self.image = pygame.Surface((self.width, self.height))
        self.image.fill(SEC_COLOR)
        self.rect = self.image.get_rect()
        
        # Determine spawn position
        self.spawn_on_valid_row()

        # Speed distribution based on probabilities:
        # 90% chance for speed 1, 9% for speed 2, 1% for speed 3
        speed_roll = random.random() * 100  # Roll between 0-100
        if speed_roll < 90:
            base_speed = 1
        elif speed_roll < 99:
            base_speed = 2
        else:
            base_speed = 3
            
        # Randomly choose direction (positive or negative)
        self.speed = base_speed * random.choice([-1, 1])
        
        # Adjust position based on speed direction
        if self.speed > 0:  # Moving right
            self.rect.centerx = -self.width  # Spawn on left
        else:  # Moving left
            self.rect.centerx = SCREEN_WIDTH + self.width  # Spawn on right

        # Border
        self.border_thickness = 1
        self.border_color = WHITE
        self.enemy_border = pygame.Rect(
            self.rect.x - self.border_thickness,
            self.rect.y - self.border_thickness,
            self.rect.width + 2 * self.border_thickness,
            self.rect.height + 2 * self.border_thickness
        )

    def spawn_on_valid_row(self):
        # Calculate valid row positions (9 rows)
        valid_rows = []
        for i in range(9):
            row_y = int((i + 0.5) * SPRITE_HEIGHT)
            valid_rows.append(row_y)
        
        # Select a random valid row
        self.rect.centery = random.choice(valid_rows)

    def update(self, player, enemies):
        previous_pos = self.rect.copy()

        # Avoid collision with other enemies
        for other in enemies:
            if other != self and self.rect.colliderect(other.rect):
                self.rect = previous_pos
                return

        # Move based on speed
        self.rect.x += self.speed

        # Check if new position collides with bars
        if (self.rect.colliderect(player.leftr) or 
            self.rect.colliderect(player.rightr)):
            self.rect = previous_pos

        # Respawn if enemy goes off screen
        if (self.speed > 0 and self.rect.left > SCREEN_WIDTH + self.width) or \
           (self.speed < 0 and self.rect.right < -self.width):
            self.spawn_on_valid_row()
            if self.speed > 0:
                self.rect.centerx = -self.width
            else:
                self.rect.centerx = SCREEN_WIDTH + self.width

    def draw(self, surface):
        self.enemy_border.x = self.rect.x - self.border_thickness
        self.enemy_border.y = self.rect.y - self.border_thickness
        
        surface.blit(self.image, self.rect)
        pygame.draw.rect(surface, self.border_color, self.enemy_border, self.border_thickness)

if __name__ == "__main__":
    game = Game()
    game.run()

