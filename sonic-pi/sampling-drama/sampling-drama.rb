# sampling-drama.rb
#
# https://soundcloud.com/joenio/sampling-drama
#
# Este código é uma adaptação do som "Sonic Dreams" por "Sam Aaron"
# e faz parte das minhas experiências e aprendizado de linguagens e
# ferramentas para edição, composição e live coding com música.
#
# Joenio Costa - joenio@joenio.me - Dezembro de 2016
#
# Sonic Dreams
# rand-seed-ver 32
# Coded by Sam Aaron
# Video: https://vimeo.com/110416910

use_debug false
load_samples [:bd_haus, :elec_blip, :ambi_lunar_land]

audiofile1 = "~/src/musica/sonic-pi/sampling-drama/WhatsApp1.wav"
audiofile2 = "~/src/musica/sonic-pi/sampling-drama/WhatsApp2.wav"

define :bd do
  cue :in_relentless_cycles
  16.times do
    sample :bd_haus, amp: 4, cutoff: 120
    sleep 0.5
  end
  cue :winding_everywhichway
  2.times do
    2.times do
      sample :bd_haus, amp: 4, cutoff: 120
      sleep 0.25
    end
    sample :ambi_lunar_land
    sleep 0.25
  end
end

define :drums do |level, b_level=1, rand_cf=false|
  synth :fm, note: :e2, release: 0.1, amp: b_level * 3, cutoff: 130
  co = rand_cf ? rrand(110, 130) : 130
  a  = rand_cf ? rrand(0.3, 0.5) : 0.6
  n  = rand_cf ? :bnoise         : :noise
  synth :noise, release: 0.05, cutoff: co, res: 0.95, amp: a if level > 0
  sample :elec_blip, amp: 2, rate: 2, pan: rrand(-0.8, 0.8) if level > 1
  sleep 1
end

define :synths do |s_name, co, n=:e2|
  use_synth s_name
  use_transpose 0
  use_synth_defaults detune: [12,24].choose, amp: 1, pan: lambda{rrand(-1, 1)}, cutoff: co, pulse_width: 0.12, attack: rrand(0.2, 0.5), release: 0.5 ,  mod_phase: 0.25, mod_invert_wave: 1
  play :e1, mod_range: [7, 12].choose
  sleep 0.125
  play :e3, mod_range: [7, 12].choose
  sleep [0.25, 0.5].choose
  play n, mod_range: 12
  sleep 0.5
  play chord(:e2, :minor).choose, mod_range: 12
  sleep 0.25
end

puts 'Parte 1'

in_thread(name: :bassdrums) do
  use_random_seed 0
  sleep 6
  3.times do
    bd
  end
  sleep 28
  live_loop :bd do
    bd
  end
end

in_thread(name: :drums) do
  use_random_seed 0
  level = -1
  with_fx :echo do |e|
    puts "Part2 2"
    2.times do
      drums level, 0.8
      drums(level)
      level += 1
    end
    cue :dreams
    drums 1, 1, true
    2.times do
      m = choose [shuffle(:within_dreams), :within_dreams, :dreams_within]
      cue m
      drums 2, 1, true
    end
    live_loop :drums do
      drums 1
      cue " " * rand_i(32)
      at 1 do
        cue "  " * rand_i(32)
      end
      drums 2
    end
  end
end

in_thread do
  use_random_seed 0
  sleep 12
  puts "Parte 3"
  use_synth_defaults phase: 0.5, res: 0.5, cutoff: 80, release: 5, wave: 1
  1.times do
    [80, 90, 100].each do |cf|
      sample audiofile1, amp: 1.5
      sleep 0.5
      use_merged_synth_defaults cutoff: cf
      puts "1" * 30
      synth :zawa, note: :e2, phase: 0.25
      synth :zawa, note: :a1
      sleep 5
    end
    4.times do |t|
      with_fx :reverb do
        with_fx :echo do
          with_fx :panslicer do
            sample audiofile1, amp: 3, start: 0.8, attack: 0.5
          end
        end
      end
      sleep 0.2
      synth :zawa, note: :e2, phase: 0.25, res: rrand(0.8, 0.9), cutoff: [100, 105, 110, 115][t]
      sleep 2
    end
  end
end

with_fx :reverb do
  sample audiofile2, amp: 2, start: 0.5, finish: 0.75, attack: 1.3
end
sleep 1
with_fx :reverb do
  with_fx :echo, decay: 3 do
    sample audiofile2, amp: 2, start: 0.5, finish: 0.75, attack: 0.8
  end
end
sleep 1
with_fx :reverb do
  with_fx :echo, decay: 8 do
    sample audiofile2, amp: 2, start: 0.5, finish: 0.75
  end
end

sleep 45
puts "Parte 4"
3.times do
  sample audiofile2, amp: 2
  sleep 4
  sample audiofile2, amp: 2, start: 0.42
  sleep 2.35
  sample audiofile2, amp: 2, start: 0.5, finish: 0.75, attack: 0.8
  sleep 1
  sample audiofile2, amp: 2, start: 0.5, finish: 0.75, attack: 0.8
  sleep 1
end
