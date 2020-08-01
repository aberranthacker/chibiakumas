
               .nolist

               .global start # make the entry point available to a linker
               .global slide09
               .global slide10
               .global slide11
               .global slide12
               .global slide13
               .global slide14
               .global slide15

               .include "./core_defs.s"

               .equiv  Ep1IntroSlidesSizeWords, (end - start) >> 1
               .global Ep1IntroSlidesSizeWords

               .=FB0 + 6000

start:
  slide09: .incbin "build/ep1-intro/ep1-intro-slide09.raw.lzsa1"
  slide10: .incbin "build/ep1-intro/ep1-intro-slide10.raw.lzsa1"
  slide11: .incbin "build/ep1-intro/ep1-intro-slide11.raw.lzsa1"
  slide12: .incbin "build/ep1-intro/ep1-intro-slide12.raw.lzsa1"
  slide13: .incbin "build/ep1-intro/ep1-intro-slide13.raw.lzsa1"
  slide14: .incbin "build/ep1-intro/ep1-intro-slide14.raw.lzsa1"
  slide15: .incbin "build/ep1-intro/ep1-intro-slide15.raw.lzsa1"
end:
