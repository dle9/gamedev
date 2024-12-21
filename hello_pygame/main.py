import pygame, sys, random
from pygame.locals import *

# ======================================================
# ====================== SETTINGS ======================
# ======================================================
SPRITE_WIDTH = 60
SPRITE_HEIGHT = 100
SCREEN_WIDTH = 1900
SCREEN_HEIGHT = 300
FPS = 60

# Space: Flip player direction
# Easy Rows:  ! , . " ? ' : ; ( )
# Med Rows:  ! , . " ? ' : ; ( ) < > { } [ ] 
# Hard Rows: ! , . " ? ' : ; ( ) < > { } [ ] # $ % & *

PRIM_COLOR = (80, 107, 127) # nordic
SEC_COLOR = (226, 153, 140) # pink eye
BG_COLOR = (40, 44, 53) # ebony night
HL1_COLOR = (241, 222, 123) # sunny
HL2_COLOR = (93, 102, 88) # ebony forest

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
        self.enemies = [Enemy() for _ in range(3)]
        self.difficulty = "easy"
 
    def init(self):
        pygame.init()
        self.display_surf = pygame.display.set_mode(self.size, pygame.HWSURFACE | pygame.DOUBLEBUF)
        self.running = True
        self.fps = pygame.time.Clock()
        pygame.display.set_caption("My first game!")

    # ======================== Utility Functions ========================
    def handle_event(self, event):
        if event.type == pygame.QUIT:
            self.running = False

    def loop(self):
        self.player.update()
        for e in self.enemies:
            e.update()

    def render(self):
        self.display_surf.fill(BG_COLOR)

        self.player.draw(self.display_surf)
        for e in self.enemies:
            e.draw(self.display_surf)

        pygame.display.update()
        self.fps.tick(FPS)

    def cleanup(self):
        pygame.quit()
        sys.exit()
 
    # =========================== Game Loop ===========================
    def run(self):
        self.init()
 
        while (self.running):
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
 
    def update(self):
        pressed_keys = pygame.key.get_pressed()
            
        if pressed_keys[K_q]:
            self.rect.center = (SCREEN_WIDTH // 2, SPRITE_HEIGHT // 2)
        elif pressed_keys[K_w]:
            self.rect.center = (SCREEN_WIDTH // 2, SPRITE_HEIGHT + SPRITE_HEIGHT // 2)
        elif pressed_keys[K_e]:
            self.rect.center = (SCREEN_WIDTH // 2, 2 * SPRITE_HEIGHT + SPRITE_HEIGHT // 2)
        elif pressed_keys[K_r]:
            self.rect.center = (SCREEN_WIDTH // 2, 3 * SPRITE_HEIGHT + SPRITE_HEIGHT // 2)

    def draw(self, surface):
        surface.blit(self.image, self.rect)

class Enemy(pygame.sprite.Sprite):

    def __init__(self):
        super().__init__()

        # sprite
        self.width = SPRITE_WIDTH
        self.height = SPRITE_HEIGHT
        self.image = pygame.Surface((self.width, self.height))
        self.image.fill(SEC_COLOR)

        self.rect = self.image.get_rect()
        self.rect.center = (random.randint(0, SCREEN_WIDTH), random.randint(0, SCREEN_HEIGHT))
 
    def update(self):
        pass

    def draw(self, surface):
        surface.blit(self.image, self.rect) 
 
if __name__ == "__main__":
    game = Game()
    game.run()
