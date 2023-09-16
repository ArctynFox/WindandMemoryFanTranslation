class Window_Message < Window_Base
alias vis_update update
def update
vis_update
if $game_message.visible
self.visible = !Input.press?(:L)
@back_sprite.visible = self.visible if @background == 1
end
end
end