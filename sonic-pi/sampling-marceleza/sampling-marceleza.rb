# sampling-marceleza.rb
#
# https://soundcloud.com/joenio/sampling-marceleza
#
# Este código é uma adaptação do som "Blimp Zones" por "Sam Aaron"
# e faz parte das minhas experiências e aprendizado de linguagens e
# ferramentas para edição, composição e live coding com música.
#
# Joenio Costa - joenio@joenio.me - Dezembro de 2016
#
# Blimp Zones
# Coded by Sam Aaron

use_debug false
use_random_seed 667
load_sample :ambi_lunar_land

audiofile = "~/src/musica/sonic-pi/sampling-marceleza/WhatsApp.wav"

sleep 1

live_loop :foo do
  with_fx :reverb, kill_delay: 0.2, room: 0.3 do
    4.times do
      use_random_seed 4000
      8.times do
        sleep 0.25
        play chord(:e3, :m7).choose, release: 0.1, pan: rrand(-1, 1, res: 0.9), amp: 1
      end
    end
  end
end

live_loop :bar, auto_cue: false do
  if rand < 0.25
    sample :ambi_lunar_land
    puts :comet_landing
  end
  sleep 8
end

live_loop :baz, auto_cue: false do
  tick
  sleep 0.25
  cue :beat, count: look
  sample :bd_haus, amp: factor?(look, 8) ? 3 : 2
  sleep 0.25
  use_synth :fm
  play :e2, release: 1, amp: 1 if factor?(look, 4)
  synth :noise, release: 0.051, amp: 0.5
end

2.times do
  sleep 1
  sample audiofile, sustain: 1.1, attack: 0.2, pitch: 1, amp: 0.8
  sleep 1.1
  sample audiofile, sustain: 1.2, attack: 0.2, pitch: 0.7, amp: 0.8
  sleep 1.1
  sample audiofile, sustain: 3.55, attack: 0.2, pitch: 0.9, amp: 1, release: 0.6
  
  sleep 4.2
  
  2.times do
    with_fx :echo do
      sample audiofile, start: 0.09, finish: 0.13, attack: 0.4, release: 0.4, amp: 0.7
    end
    sleep 2.1
  end
  with_fx :echo do
    sample audiofile, start: 0.09, finish: 0.13, attack: 0.4, release: 0.4, amp: 0.7
  end
end

sleep 0.7

4.times do
  with_fx :echo do
    sample audiofile, start: 0.32, finish: 0.38, amp: 0.5
  end
  sleep 1
  with_fx :echo do
    with_fx :ixi_techno do
      sample audiofile, start: 0.32, finish: 0.38, amp: 0.5
    end
  end
  sleep 1
end

with_fx :echo do
  sample audiofile, start: 0.32, finish: 0.38, amp: 0.5
end

3.times do
  sample audiofile, start: 0.7, finish: 1, amp: 1, pan: -1
  sleep 1
  sample audiofile, start: 0.7, finish: 1, amp: 1, pan: 1
  sleep 1
end
