# sampling-leka.rb
#
# Este código é uma adaptação do som "Filtered Dnb" por "Sam Aaron"
# e faz parte das minhas experiências e aprendizado de linguagens e
# ferramentas para edição, composição e live coding com música.
#
# Joenio Costa - joenio@joenio.me - Dezembro de 2016
#
# Filtered Dnb
# Coded by Sam Aaron

audiofile = "~/src/musica/sonic-pi/sampling-leka/WhatsApp.wav"

define :bomdia do
  sample audiofile, start: 0.15, finish: 0.33, attack: 0.6
end

define :semmimi do
  sample audiofile, start: 0.35, finish: 0.46, attack: 0.3
end

define :verdade do
  sample audiofile, start: 0.47, finish: 0.7, attack: 0.3
end

define :naoconfio do
  sample audiofile, start: 0.7, attack: 0.5
end

define :eu do
  sample audiofile, start: 0.726, finish: 0.755
end

define :eu_eu do
  with_fx :bpf, centre: 90 do
    with_fx :gverb, dry: 8 do
      with_fx :echo do
        eu
      end
    end
  end
end

define :bomdia_eu_eu do
  bomdia
  sleep 1
  eu_eu
end

use_sample_bpm :loop_amen # loop_amen is 35 bpm

keep_drums = true
with_fx :rlpf, cutoff: 10, cutoff_slide: 4 do |c|
  live_loop :dnb do
    if keep_drums
      sample :bass_dnb_f, amp: 3
      sample :loop_amen, amp: 3
      sleep 1
      control c, cutoff: rrand(40, 120), cutoff_slide: rrand(1, 4)
    else
      # silence
      sleep 1
    end
  end
end

sleep 2

2.times do
  bomdia_eu_eu
  sleep 1
end

keep_drums = false

define :pan_pan do
  with_fx :slicer, smooth: 0.1, amp: 2 do
    play_chord (chord_degree 1, :c, :major, 3), decay: 1
    play_chord (chord_degree 1, :e4, :major, 3), decay: 1.7
  end
end

pan_pan
sleep 0.1
semmimi
sleep 0.7
keep_drums = true
sleep 0.2

2.times do
  pan_pan
  eu_eu
  sleep 2
end

eu_eu
sleep 2
keep_drums = false
verdade
sleep 0.125

4.times do |n|
  32.times do |i|
    use_bpm 70
    use_synth :tb303
    play chord("c#{3+n}", :minor).choose, attack: 0, release: 0.1, amp: 0.5 + (i / 100)
    sleep 0.125
  end
end
with_fx :flanger do
  play chord(:c6, :minor).choose, attack: 0.1, release: 4, amp: 0.65
end

keep_drums_agressivo = true

with_fx :rlpf, cutoff: 10, cutoff_slide: 4 do |c|
  live_loop :dnb_agressivo do
    if keep_drums_agressivo
      sync :dnb
      with_fx [:octaver, :ixi_techno, :echo].choose do
        sample :bass_dnb_f, amp: 7
      end
      with_fx [:reverb, :echo].choose do
        sample :loop_amen, amp: 6
      end
      sleep 1
      control c, cutoff: rrand(40, 120), cutoff_slide: rrand(1, 4)
    else
      sleep 1
    end
  end
end

sleep 1
pan_pan
sleep 2
naoconfio
keep_drums = true
sleep 1

3.times do
  naoconfio
  sleep 1.89
end

sleep 8
keep_drums = keep_drums_agressivo = false
sleep 2

with_fx :echo, decay: 4 do
  naoconfio
end
