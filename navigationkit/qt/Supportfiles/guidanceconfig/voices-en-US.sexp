(nav-instruct (command-set-version [uint]103  media-type __MEDIATYPE__ media-sub-type __MEDIASUBTYPE__ player __PLAYER__)
;
; Define the basic sound for each turn.
; This allows many subsequent rules to be combined since they 
; only differ in the basic turn command
;
  (turn-sounds ()
;M1 - Initial maneuver: [Head toward <first cross street> on <current road>, then] <next maneuver at current position>
    (define-turn-sound (turn M1. pos continue|prepare)
        ;If we have a cross street, then say this part
        (if-condition ()
            (expression ()
                (value (key first-maneuver-cross-street))
            )
           (then ()
               ;head toward <first cross street>
               (sound (id head))
               (sound (id toward))
               ;<first cross street>
               (first-maneuver-cross-street ())
               ;on <current road>
               (sound (id on))
               (if-opronun-available ()
                    (opronun ())
               )
               (if-not-opronun-available ()
                    (sound (id the-highlighted-route))
               )
               ;then
			   (sound (id pause))
               (sound (id then))
               ;<next maneuver announcement at current position>
               (next ()
                    (turn-sound ())
               )
            )
        )
    )
; TR.R|SR|HR|TR.L|SL|HL - Turn
    (define-turn-sound (turn TR.R|TR.SR|TR.HR|NR.R|TR.L|TR.SL|TR.HL|NR.L pos continue)
      (if (turn TR.R|NR.R stacknext * next *)
       ;turn right
       (sound (id right)))
      (if (turn TR.L|NR.L stacknext * next *)
       ;turn left
       (sound (id left)))
      (if (turn TR.SR stacknext * next *)
       ;make a slight right turn
       (sound (id slight-right)))
      (if (turn TR.SL stacknext * next *)
       ;make a slight left turn
       (sound (id slight-left)))
      (if (turn TR.HR stacknext * next *)
       ;make a hard right turn
       (sound (id hard-right)))
      (if (turn TR.HL stacknext * next *)
       ;make a hard left turn
       (sound (id hard-left))))
    (define-turn-sound (turn TR.R|TR.SR|TR.HR|NR.R|TR.L|TR.SL|TR.HL|NR.L pos prepare|turn|past-turn)
       (if-condition ()
         (expression ()
           ;lane guidance and not natural guidance and not stacked-sound
           (and ()
             (value (key lane-guidance))
             (not () (value (key natural-guidance)))
             (not () (value (key stacked-sound)))))
         (then ()
           ;use lane guidance
           ;use the right/left two lanes
           (sound (id use))
           (lgpreppronun ())
           (lgpronun ())
           (if (turn TR.R|NR.R|TR.L|NR.L stacknext * next *)
             ;to turn
             (sound (id to-turn)))
           (if (turn TR.SR stacknext * next *)
             ;and make a slight right turn
             (sound (id and))
             (sound (id slight-right)))
           (if (turn TR.SL stacknext * next *)
             ;and make a slight left turn
             (sound (id and))
             (sound (id slight-left)))
           (if (turn TR.HR stacknext * next *)
             ;and make a hard right turn
             (sound (id and))
             (sound (id hard-right)))
           (if (turn TR.HL stacknext * next *)
             ;and make a hard left turn
             (sound (id and))
             (sound (id hard-left)))
         )
         (else ()
           ;no lane guidance
           ;handle special case for street counts in turn position
           (if-condition ()
             (expression ()
               ; natural guidance & not stacked sound & gp-street-count
               (and ()
                 (value (key natural-guidance))
                 (not () (value (key stacked-sound)))
                 (value (key gp-street-count))))
             (then ()
               ;second/third right is played only on turn position
               (if-condition ()
                 (expression ()
                   (value (key position-prepare)))
                 (then ()
                   (if (turn TR.R|NR.R stacknext * next *)
                     ;turn right
                     (sound (id right)))
                   (if (turn TR.L|NR.L stacknext * next *)
                     ;turn left
                     (sound (id left)))
                   (if (turn TR.SR stacknext * next *)
                     ;make a slight right turn
                     (sound (id slight-right)))
                   (if (turn TR.SL stacknext * next *)
                     ;make a slight left turn
                     (sound (id slight-left)))
                   (if (turn TR.HR stacknext * next *)
                     ;make a hard right turn
                     (sound (id hard-right)))
                   (if (turn TR.HL stacknext * next *)
                     ;make a hard left turn
                     (sound (id hard-left)))
                 )
                 (else ()
                   ;take the second/third right
                   (sound (id take-the))
                   (tgppronun ())
                 )
               )
             )
             (else ()
               (if (turn TR.R|NR.R stacknext * next *)
                 ;turn right
                 (sound (id right)))
               (if (turn TR.L|NR.L stacknext * next *)
                 ;turn left
                 (sound (id left)))
               (if (turn TR.SR stacknext * next *)
                 ;make a slight right turn
                 (sound (id slight-right)))
               (if (turn TR.SL stacknext * next *)
                 ;make a slight left turn
                 (sound (id slight-left)))
               (if (turn TR.HR stacknext * next *)
                 ;make a hard right turn
                 (sound (id hard-right)))
               (if (turn TR.HL stacknext * next *)
                 ;make a hard left turn
                 (sound (id hard-left)))
               ;play the natural guidance only if not in a stacked sound
               (if-condition ()
                 (expression ()
                   (and ()
                     (value (key natural-guidance))
                     (not () (value (key stacked-sound)))))
                 (then ()
                   (if-condition ()
                     (expression ()
                       (value (key position-prepare)))
                     (then ()
                       (pgppreppronun ())
                       (pgppronun ())
                     )
                     (else ()
                       (tgppreppronun ())
                       (tgppronun ())
                     )
                   )
                 )
               )
             )
           )
         )
       )
    )
; UT. - U Turn --UPDATED
    (define-turn-sound (turn UT. pos continue)
       ;make a legal u-turn
       (sound (id make-a-legal-u-turn)))
    (define-turn-sound (turn UT. pos prepare)
       ;get ready to make a legal u-turn
       (sound (id get-ready-to))
       (sound (id make-a-legal-u-turn)))
    (define-turn-sound (turn UT. pos turn|past-turn)
      ;make the next legal u-turn
      (sound (id make-legal-uturn)))
; EN.|R|L - Enter Highway straight ahead|on the Right/Left
    (define-turn-sound (turn EN.|EN.R|EN.L pos continue)
      ;take the ramp
      (sound (id ramp)))
    (define-turn-sound (turn EN.|EN.R|EN.L pos prepare|turn|past-turn)
      ; only provide lane guidance if natural guidance is not available
      (if-condition ()
        (expression ()
          (and ()
            (value (key lane-guidance))
            (not () (value (key natural-guidance)))
            (not () (value (key stacked-sound)))
          )
        )
        (then ()
          ;Use lane guidance
          ;use the center/right/left lanes and take the ramp
          (sound (id use))
          (lgpreppronun ())
          (lgpronun ())
          (sound (id and))
          ;take the ramp 
          (sound (id ramp))
        )
        (else ()
          (if (turn EN. stacknext * next *)
            ;take the ramp straight ahead
            (sound (id ramp-straight)))
          (if (turn EN.R stacknext * next *)
            ;take the ramp on the right
            (sound (id ramp-right)))
          (if (turn EN.L stacknext * next *)
            ;take the ramp on the left
            (sound (id ramp-left)))
          (if-condition ()
            (expression ()
              (and ()
                (value (key natural-guidance))
                (not () (value (key stacked-sound)))))
            (then ()
              ;choose the natural guidance point depending on the position
              (if-condition ()
                (expression ()
                  (value (key position-prepare))
                )
                (then ()
                  (pgppreppronun ())
                  (pgppronun ())
                )
                (else ()
                  (tgppreppronun ())
                  (tgppronun ())
                )
              )
            )
          )
        )
      )
    )
; EX.|L|R - Exit Highway --UPDATED REVIEW
; Continue announcement is the same for straight/left/right
    (define-turn-sound (turn EX.|EX.R|EX.L pos continue)
      (if-hwy-exit ()
        ;take exit 13B
        (sound (id take-exit))
        (hwyexitpronun())
        (sound (id pause))
      )
      (if-not-hwy-exit ()
        ;take the exit
        (sound (id take-the))
        (sound (id exit))
      )
      ;straight ahead/on the right/on the left
      (if-not-lane-guidance ()
        (if (turn EX. stacknext * next *)
          (sound (id straight-ahead)))
        (if (turn EX.R stacknext * next *)
          (sound (id on-the-right)))
        (if (turn EX.L stacknext * next *)
          (sound (id on-the-left)))
      )
      (if-dpronun-available ()
        ;to Aliso Creek
        (sound (id to))
        (dpronun ())
      )
    )
    (define-turn-sound (turn EX.|EX.R|EX.L pos prepare|turn|past-turn)
      (if-condition ()
        (expression ()
          (and ()
            (value (key lane-guidance))
            (not() (value (key stacked-sound)))
          )
        )
        (then ()
          ;use the center/right/left lanes and
          (sound (id use))
          (lgpreppronun ())
          (lgpronun ())
          (sound (id and))
        )
      )
      (if-hwy-exit ()
        ;take exit 13B
        (sound (id take-exit))
        (hwyexitpronun())
        (sound (id pause))
      )
      (if-not-hwy-exit ()
        ;take the exit
        (sound (id take-the))
        (sound (id exit))
      )
      ;on the left | on the right | straight ahead
      (if-condition ()
        (expression ()
          (or ()
            (not() (value (key lane-guidance)))
            (value (key stacked-sound))
          )
        )
        (then ()
          ;straight ahead/right/left
          (if (turn EX. stacknext * next *)
            (sound (id straight-ahead)))
          (if (turn EX.R stacknext * next *)
            (sound (id on-the-right)))
          (if (turn EX.L stacknext * next *)
            (sound (id on-the-left)))
        )
      )
      (if-dpronun-available ()
        ;to Aliso Creek
        (sound (id to))
        (dpronun ())
      )
    )
; MR.R - Merge into traffic on the right --NO LONGER USED IN LONG ANNOUNCEMENT
    (define-turn-sound (turn MR.R pos continue)
      (sound (id merge-right)))
    (define-turn-sound (turn MR.R pos prepare)
      (sound (id merge-right)))
    (define-turn-sound (turn MR.R pos turn|past-turn)
      (sound (id merge-right)))
; MR.L - Merge into traffic on the left --NO LONGER USED IN LONG ANNOUNCEMENT
    (define-turn-sound (turn MR.L pos continue)
      (sound (id merge-left)))
    (define-turn-sound (turn MR.L pos prepare)
      (sound (id merge-left)))
    (define-turn-sound (turn MR.L pos turn|past-turn)
      (sound (id merge-left)))
; KS.|R|L - Keep for surface streets
    (define-turn-sound (turn KS.|KS.R|KS.L pos continue)
      (if (turn KS. stacknext * next *)
        ;keep straight
        (sound (id keep-straight)))
      (if (turn KS.L stacknext * next *)
        ;keep to the left
        (sound (id keep-to-the-left)))
      (if (turn KS.R stacknext * next *)
        ;keep to the right
        (sound (id keep-to-the-right))))
    (define-turn-sound (turn KS.|KS.L|KS.R pos prepare|turn|past-turn)
      (if-condition ()
        (expression ()
          (and ()
            (value (key lane-guidance))
            (not () (value (key natural-guidance)))
            (not () (value (key stacked-sound)))
          )
        )
        (then ()
          ;Use lane guidance
          ;use the center lane|left/right two lanes
          (sound (id use))
          (lgpreppronun ())
          (lgpronun ())
          (sound (id at-the-fork))
          (if-condition ()
            (expression()
              (and ()
                (value (key position-prepare))
				(value (key dpronun-available))
              )
            )
            (then ()
              (if-dpronun-available ()
                (sound (id pause)))
            )
          )
        )
        (else ()
          ;No lane guidance
          (if (turn KS. stacknext * next *)
            ;keep straight
            (sound (id keep-straight)))
          (if (turn KS.L stacknext * next *)
            ;keep to the left
            (sound (id keep-to-the-left)))
          (if (turn KS.R stacknext * next *)
            ;keep to the right
            (sound (id keep-to-the-right)))
          (if-condition ()
            (expression ()
              (and ()
                (value (key natural-guidance))
                (not() (value (key stacked-sound)))
              )
            )
            (then ()
              ;choose the natural guidance point depending on the position
              (if-condition ()
                (expression ()
                  (value (key position-prepare)))
                (then ()
                  (pgppreppronun ())
                  (pgppronun ())
                  (if-condition ()
                    (expression()
                      (and ()
                        (value (key position-prepare))
                        (value (key dpronun-available))
                      )
                    )
                    (then ()
                      (if-dpronun-available ()
                        (sound (id pause)))
                    )
                  )
                )
                (else ()
                  (tgppreppronun ())
                  (tgppronun ())
                  (if-condition ()
                    (expression()
                      (and ()
                        (value (key position-prepare))
                        (value (key dpronun-available))
                      )
                    )
                    (then ()
                      (if-dpronun-available ()
                        (sound (id pause)))
                    )
                  )
                )
              )
            )
            (else ()
              (sound (id at-the-fork))
              (if-condition ()
                (expression ()
                  (and ()
                     (value (key position-prepare))
                     (value (key dpronun-available))
                  )
                )
                (then ()
                  (if-dpronun-available ()
                    (sound (id pause)))
                )
              )
            )
          )
        )
      )
    )
; ST.L|R - Stay on road
    (define-turn-sound (turn ST.|ST.R|ST.L pos continue)
      (if-dpronun-available ()
        (sound (id stay)))
      (if-not-dpronun-available ()
        (sound (id stay-on-this-road))))
; SH.L|R - Stay on highway
    (define-turn-sound (turn SH.|SH.R|SH.L pos continue)
      (if-dpronun-available ()
        (sound (id continue)))
      (if-not-dpronun-available ()
        (sound (id continue-on-this-highway))))
; ST.|L|R|SH.|L|R - Stay on Highway/Road
    (define-turn-sound (turn ST.|ST.R|ST.L|SH.|SH.L|SH.R pos prepare|turn|past-turn)
      (if-condition ()
        (expression ()
          (and ()
            (value (key lane-guidance))
            (not () (value (key natural-guidance)))
            (not () (value (key stacked-sound)))
          )
        )
        (then ()
          ;Use lane guidance
          ;use the left/right two lanes
          (sound (id use))
          (lgpreppronun ())
          (lgpronun ())
        )
        (else ()
          ;No lane guidance
          (if (turn ST.|SH. stacknext * next *)
            ;keep straight
            (sound (id keep-straight)))
          (if (turn ST.L|SH.L stacknext * next *)
            ;keep to the left
            (sound (id keep-to-the-left)))
          (if (turn ST.R|SH.R stacknext * next *)
            ;keep to the right
            (sound (id keep-to-the-right)))
          (if-condition ()
            (expression ()
              (and ()
                (value (key natural-guidance))
                (not() (value (key stacked-sound)))
              )
            )
            (then ()
              ;choose the natural guidance point depending on the position
              (if-condition ()
                (expression ()
                  (value (key position-prepare)))
                (then ()
                  (pgppreppronun ())
                  (pgppronun ())
                )
                (else ()
                  (tgppreppronun ())
                  (tgppronun ())
                )
              )
            )
          )
        )
      )
    )
; KP.|L|R - This instruction will be deprecated when KH and KS are added in the server
    (define-turn-sound (turn KP.|KP.L|KP.R pos continue)
      (if (turn KP. stacknext * next *)
        ;keep straight
        (sound (id keep-straight)))
      (if (turn KP.L stacknext * next *)
        ;keep to the left
        (sound (id keep-to-the-left)))
      (if (turn KP.R stacknext * next *)
        ;keep to the right
        (sound (id keep-to-the-right))))
    (define-turn-sound (turn KP.|KP.L|KP.R pos prepare|turn|past-turn)
      (if-condition ()
        (expression ()
          (and ()
            (value (key lane-guidance))
            (not () (value (key natural-guidance)))
            (not () (value (key stacked-sound)))
          )
        )
        (then ()
          ;Use lane guidance
          ;use the left/right two lanes
          (sound (id use))
          (lgpreppronun ())
          (lgpronun ())
        )
        (else ()
          ;No lane guidance
          (if (turn KP. stacknext * next *)
            ;keep straight
            (sound (id keep-straight)))
          (if (turn KP.L stacknext * next *)
            ;keep to the left
            (sound (id keep-to-the-left)))
          (if (turn KP.R stacknext * next *)
            ;keep to the right
            (sound (id keep-to-the-right)))
          (if-condition ()
            (expression ()
              (and ()
                (value (key natural-guidance))
                (not() (value (key stacked-sound)))
              )
            )
            (then ()
              ;choose the natural guidance point depending on the position
              (if-condition ()
                (expression ()
                (value (key position-prepare)))
                (then ()
                  (pgppreppronun ())
                    (pgppronun ())
                )
                (else ()
                  (tgppreppronun ())
                  (tgppronun ())
                )
              )
            )
          )
        )
      )
    )
; KH.|L|R - Keep for highways
    (define-turn-sound (turn KH.|KH.R|KH.L pos continue)
      (if-dpronun-available ()
       ;In about 1 mile take [exit 13B] to I-5
       (sound (id take))
        (if-hwy-exit ()
          ;exit 13B
          (sound (id exit))
          (hwyexitpronun())
          (sound (id pause))
        )
        (if-not-hwy-exit ()
          (sound (id the))
          (sound (id exit))
        )
      )
      (if-not-dpronun-available ()
        ;In about 1 mile keep to the right [and take exit 13B]
        ;keep straight
        (if (turn KH. stacknext * next *)
          (sound (id keep-straight)))
        ;keep to the right|left
        (if (turn KH.R stacknext * next *)
          (sound (id keep-to-the-right)))
        (if (turn KH.L stacknext * next *)
          (sound (id keep-to-the-left)))
        (if-hwy-exit ()
          ;and take exit 13B
          (sound (id and))
          (sound (id take-exit))
          (hwyexitpronun())
          (sound (id pause))
        )
      )
    )
    (define-turn-sound (turn KH.|KH.R|KH.L pos prepare|turn|past-turn)
      (if-condition ()
        (expression ()
          (and ()
            (value (key lane-guidance))
            (not () (value (key stacked-sound)))
          )
        )
        (then ()
          ;[In about 1 mile] use the right two lanes [and take exit 13B [to I-5]]
          ;[In about 1 mile] use the right two lanes [and take I-5]
          (sound (id use))
          (lgpreppronun ())
          (lgpronun ())
        )
        (else ()
          ;[In about 1 mile] keep to the right [and take exit 13B [to I-5]] 
          ;[In about 1 mile] keep to the right [and take I-5]
          (if (turn KH. stacknext * next *)
            (sound (id keep-straight)))
          ;keep to the right|left
          (if (turn KH.R stacknext * next *)
            (sound (id keep-to-the-right)))
          (if (turn KH.L stacknext * next *)
            (sound (id keep-to-the-left)))
        )
      )
      (if-hwy-exit ()
        ;and take exit 13B
        (sound (id and))
        (sound (id take-exit))
        (hwyexitpronun())
		(if-condition ()
          (expression()
            (value (key position-prepare))
          )
          (then ()
            (if-dpronun-available ()
              (sound (id pause)))
          )
        )
      )
    )
; NC. - Name Change (Continue)
    (define-turn-sound (turn NC. pos *)
      (sound (id continue)))
; CO. - Continue On
    (define-turn-sound (turn CO. pos *)
      (sound (id continue)))
; DT. - Destination
    (define-turn-sound (turn DT. pos continue)
      (sound (id dest-straight)))
    (define-turn-sound (turn DT. pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (sound (id dest-straight))
	)
    (define-turn-sound (turn DT. pos turn|past-turn)
      (sound (id arrived-dest)))
; DT.R - Destination on the right
    (define-turn-sound (turn DT.R pos continue)
      (sound (id dest-right)))
    (define-turn-sound (turn DT.R pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (sound (id dest-right)))
    (define-turn-sound (turn DT.R pos turn|past-turn)
      (sound (id arrived-dest))
      (sound (id on-the-right)))
; DT.L - Destination on the left
    (define-turn-sound (turn DT.L pos continue)
      (sound (id dest-left)))
    (define-turn-sound (turn DT.L pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (sound (id dest-left)))
    (define-turn-sound (turn DT.L pos turn|past-turn) 
      (sound (id arrived-dest))
      (sound (id on-the-left)))
; DT.U - Destination Unknown (Continue)
    (define-turn-sound (turn DT.U pos *)
      (sound (id continue))) 
; RE. - Enter Traffic Circle - TODO implement new sounds
    (define-turn-sound (turn RE. pos continue)
      (if (turn * stacknext * next RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10)
        ;take the first|second|...|tenth exit at the roundabout on Main street
        (next ()
          (turn-sound (pos prepare))))
      (if (turn * stacknext * next DT.|DT.L|DT.R)
        ;destination inside the roundabout
        (sound (id enter-the-roundabout))
        (sound (id toward))
        (sound (id your-dest))
      )
    )
    (define-turn-sound (turn RE. pos prepare)
      (if (turn * stacknext * next RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10)
        ;In about <distance>, take the first|second|...|tenth exit at the roundabout on Main street
        (next ()
          (sound (id in-about))
          (rdistpronun ())
          ;Add pause
          (sound (id pause))
          (turn-sound (pos prepare))))
      (if (turn * stacknext * next DT.|DT.L|DT.R)
        ;destination inside the roundabout
        (sound (id in-about))
        (rdistpronun ())
        ;Add pause
        (sound (id pause))
        ;enter the roundabout toward your destination
        (sound (id enter-the-roundabout))
        (sound (id toward))
        (sound (id your-dest))
      )
    )
	(define-turn-sound (turn RE. pos turn|past-turn)
      (if (turn * stacknext * next RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10)
        ;take the first|second|...|tenth exit at the roundabout on Main street
        (next ()
          (turn-sound (pos prepare))))
      (if (turn * stacknext * next DT.|DT.L|DT.R)
        ;destination inside the roundabout
        ;enter the roundabout toward your destination
        (sound (id enter-the-roundabout))
        (sound (id toward))
        (sound (id your-dest))
      )
    )
; RX.1 - Exit Traffic Cirle 1st Exit
    (define-turn-sound (turn RX.1 pos prepare)
      (sound (id take-1-exit-rb)))
    (define-turn-sound (turn RX.1 pos turn|past-turn)
      (sound (id exit)))
; RX.2 - Exit Traffic Cirle 2nd Exit
    (define-turn-sound (turn RX.2 pos prepare)
      (sound (id take-2-exit-rb)))
    (define-turn-sound (turn RX.2 pos turn|past-turn)
      (sound (id exit)))
; RX.3 - Exit Traffic Cirle 3rd Exit
    (define-turn-sound (turn RX.3 pos prepare)
      (sound (id take-3-exit-rb)))
    (define-turn-sound (turn RX.3 pos turn|past-turn)
      (sound (id exit)))
; RX.4 - Exit Traffic Cirle 4th Exit
    (define-turn-sound (turn RX.4 pos prepare)
      (sound (id take-4-exit-rb)))
    (define-turn-sound (turn RX.4 pos turn|past-turn)
      (sound (id exit)))
; RX.5 - Exit Traffic Cirle 5th Exit
    (define-turn-sound (turn RX.5 pos prepare)
      (sound (id take-5-exit-rb)))
    (define-turn-sound (turn RX.5 pos turn|past-turn)
      (sound (id exit)))
; RX.6 - Exit Traffic Cirle 6th Exit
    (define-turn-sound (turn RX.6 pos prepare)
      (sound (id take-6-exit-rb)))
    (define-turn-sound (turn RX.6 pos turn|past-turn)
      (sound (id exit)))
; RX.7 - Exit Traffic Cirle 7th Exit
    (define-turn-sound (turn RX.7 pos prepare)
      (sound (id take-7-exit-rb)))
    (define-turn-sound (turn RX.7 pos turn|past-turn)
      (sound (id exit)))
; RX.8 - Exit Traffic Cirle 8th Exit
    (define-turn-sound (turn RX.8 pos prepare)
      (sound (id take-8-exit-rb)))
    (define-turn-sound (turn RX.8 pos turn|past-turn)
      (sound (id exit)))
; RX.9 - Exit Traffic Cirle 9th Exit
    (define-turn-sound (turn RX.9 pos prepare)
      (sound (id take-9-exit-rb)))
    (define-turn-sound (turn RX.9 pos turn|past-turn)
      (sound (id exit)))
; RX.10 - Exit Traffic Cirle 10th Exit
    (define-turn-sound (turn RX.10 pos prepare)
      (sound (id take-10-exit-rb)))
    (define-turn-sound (turn RX.10 pos turn|past-turn)
      (sound (id exit)))
; RT. - Drive straight through traffic circle (rotary/round-about)
    (define-turn-sound (turn RT. pos continue)
      (sound (id continue-straight-roundabout)))
    (define-turn-sound (turn RT. pos prepare|turn|past-turn)
      (sound (id continue-straight-roundabout)))
;OR. - Startup case: Head <compass direction> toward <street>, then turn <left/right>
    (define-turn-sound (turn OR.|OR.L|OR.R pos *)
      ;head
      (sound (id head))
      ;compass direction
      (heading-to-route-start())
      ;toward
      (sound (id toward))
      ;<street>
	  (if-opronun-available ()
        (first-maneuver-opronun ())
	  )
	  (if-not-opronun-available ()
	    (sound (id the-highlighted-route))
	  )
      (if-direction-to-route ()
        ;then
        (sound (id pause))
        (sound (id then))
        ;turn left|right
        (direction-to-route())
      )
    )
; TC. - Traffic Congestion
    (define-turn-sound (turn TC. pos *)
      (sound (id traffic-congestion)))
; TC.S - Severe Traffic Congestion
    (define-turn-sound (turn TC.S pos *)
      (sound (id traffic-congestion)))
; TI. - Traffic Incident
    (define-turn-sound (turn TI.|TI.S pos *)
      (sound (id incident-ahead)))
; FE. - Catch a Ferry
    (define-turn-sound (turn FE. pos continue)
      (sound (id you-will-board-ferry)))
    (define-turn-sound (turn FE. pos prepare|turn|past-turn)
      (sound (id take-the))
      (if-dpronun-available ()
        (dpronun()))
      (if-not-dpronun-available ()
        (sound (id ferry))))
; FX. - Exit Ferry
    (define-turn-sound (turn FX. pos continue)
      (sound (id you-will-exit-ferry)))
    (define-turn-sound (turn FX. pos turn|past-turn)
      (sound (id exit-the-ferry)))
; NR.  - Enter Private Roadway Straight Ahead
    (define-turn-sound (turn NR. pos continue)
      (sound (id enter-pvt-roadway-straight)))
    (define-turn-sound (turn NR. pos prepare)
      (sound (id enter-pvt-roadway-straight)))
    (define-turn-sound (turn NR. pos turn|past-turn)
      (sound (id enter-pvt-roadway-straight)))
; BE.R - Cross Bridge  on the Right
    (define-turn-sound (turn BE.R pos continue)
      (sound (id cross-bridge-right)))
    (define-turn-sound (turn BE.R pos prepare)
      (sound (id cross-bridge-right)))
    (define-turn-sound (turn BE.R pos turn|past-turn)
      (sound (id cross-bridge-right)))
; BE.L - Cross Bridge on the Left
    (define-turn-sound (turn BE.L pos continue)
      (sound (id cross-bridge-left)))
    (define-turn-sound (turn BE.L pos prepare)
      (sound (id cross-bridge-left)))
    (define-turn-sound (turn BE.L pos turn|past-turn)
      (sound (id cross-bridge-left)))
; BE.  - Cross Bridge Straight Ahead
    (define-turn-sound (turn BE. pos continue)
      (sound (id cross-bridge-straight)))
    (define-turn-sound (turn BE. pos prepare)
      (sound (id cross-bridge-straight)))
    (define-turn-sound (turn BE. pos turn|past-turn)
      (sound (id cross-bridge-straight)))
; TE.R - Enter Tunnel  on the Right
    (define-turn-sound (turn TE.R pos continue)
      (sound (id enter-tunnel-right)))
    (define-turn-sound (turn TE.R pos prepare)
      (sound (id enter-tunnel-right)))
    (define-turn-sound (turn TE.R pos turn|past-turn)
      (sound (id enter-tunnel-right)))
; TE.L - Enter Tunnel on the Left
    (define-turn-sound (turn TE.L pos continue)
      (sound (id enter-tunnel-left)))
    (define-turn-sound (turn TE.L pos prepare)
      (sound (id enter-tunnel-left)))
    (define-turn-sound (turn TE.L pos turn|past-turn)
      (sound (id enter-tunnel-left)))
; TE.  - Enter Tunnel Straight Ahead
    (define-turn-sound (turn TE. pos continue)
      (sound (id enter-tunnel-straight)))
    (define-turn-sound (turn TE. pos prepare)
      (sound (id enter-tunnel-straight)))
    (define-turn-sound (turn TE. pos turn|past-turn)
      (sound (id enter-tunnel-straight)))
; ES.R - Take the Stairs on the Right
    (define-turn-sound (turn ES.R pos continue)
      (sound (id stairs-right)))
    (define-turn-sound (turn ES.R pos prepare)
      (sound (id stairs-right)))
    (define-turn-sound (turn ES.R pos turn|past-turn)
      (sound (id stairs-right)))
; ES.L - Take the Stairs on the Left
    (define-turn-sound (turn ES.L pos continue)
      (sound (id stairs-left)))
    (define-turn-sound (turn ES.L pos prepare)
      (sound (id stairs-left)))
    (define-turn-sound (turn ES.L pos turn|past-turn)
      (sound (id stairs-left)))
; ES.  - Take the Stairs Straight Ahead
    (define-turn-sound (turn ES. pos  continue)
      (sound (id stairs-straight)))
    (define-turn-sound (turn ES. pos prepare)
      (sound (id stairs-straight)))
    (define-turn-sound (turn ES. pos turn|past-turn)
      (sound (id stairs-straight)))
; EE.R - Take the Escalator on the Right
    (define-turn-sound (turn EE.R pos continue)
      (sound (id escalator-right)))
    (define-turn-sound (turn EE.R pos prepare)
      (sound (id escalator-right)))
    (define-turn-sound (turn EE.R pos turn|past-turn)
      (sound (id escalator-right)))
; EE.L - Take the Escalator on the Left
    (define-turn-sound (turn EE.L pos continue)
      (sound (id escalator-left)))
    (define-turn-sound (turn EE.L pos prepare)
      (sound (id escalator-left)))
    (define-turn-sound (turn EE.L pos turn|past-turn)
      (sound (id escalator-left)))
; EE.  - Take the Escalator Straight Ahead
    (define-turn-sound (turn EE. pos continue)
      (sound (id escalator-straight)))
    (define-turn-sound (turn EE. pos prepare)
      (sound (id escalator-straight)))
    (define-turn-sound (turn EE. pos turn|past-turn)
      (sound (id escalator-straight)))
; ER.R - Take the Ramp on the Right
    (define-turn-sound (turn ER.R pos continue)
      (sound (id ramp-right)))
    (define-turn-sound (turn ER.R pos prepare)
      (sound (id ramp-right)))
    (define-turn-sound (turn ER.R pos turn|past-turn)
      (sound (id ramp-right)))
; ER.L - Take the Ramp on the Left
    (define-turn-sound (turn ER.L pos continue)
      (sound (id ramp-left)))
    (define-turn-sound (turn ER.L pos prepare)
      (sound (id ramp-left)))
    (define-turn-sound (turn ER.L pos turn|past-turn)
      (sound (id ramp-left)))
; ER.  - Take the Ramp Straight Ahead
    (define-turn-sound (turn ER. pos continue)
      (sound (id ramp-straight)))
    (define-turn-sound (turn ER. pos prepare)
      (sound (id ramp-straight)))
    (define-turn-sound (turn ER. pos turn|past-turn)
      (sound (id ramp-straight)))
; PE.  - Continue on Foot
    (define-turn-sound (turn PE. pos continue)
      (sound (id you-will-continue-by-foot)))
    (define-turn-sound (turn PE. pos prepare)
      (sound (id find-parking-and-then-foot)))
    (define-turn-sound (turn PE. pos turn|past-turn)
      (sound (id park-your-car-foot)))
; SC. - Speed camera ahead
    (define-turn-sound (turn SC. pos turn)
      (sound (id camera-alert)))
; SC.S - Camera speeding alert
    (define-turn-sound (turn SC.S pos turn)
      (sound (id turn-tone)))
; EC.|R|L - you will enter Canada
    (define-turn-sound (turn EC.|EC.R|EC.L pos continue)
      (if-dpronun-available ()
        (sound (id you-will-enter))
        (dpronun ()))
      (if-not-dpronun-available ()
        ;you will cross the country border
        (sound (id you-will))
        (sound (id cross-border))
      )
    )
; EC.|R|L - Get ready to enter Canada on the right
    (define-turn-sound (turn EC.|EC.L|EC.R pos prepare|turn|past-turn)
      (if-dpronun-available ()
        (sound (id enter))
        (dpronun ()))
      (if-not-dpronun-available ()
        ;cross the country border
        (sound (id cross-border))
      )
      (if (turn EC. stacknext * next *)
        (sound (id straight-ahead)))
      (if (turn EC.R stacknext * next *)
        (sound (id on-the-right)))
      (if (turn EC.L stacknext * next *)
        (sound (id on-the-left)))))
     
;
; Define the transition sounds associated with each type of turn
;
  (transition-sounds ()
    ; 
    ;Transition sounds for keeps and stays
    ; 
    (define-transition-sound (turn KH.L|KH.R|KH. pos continue)
      ;to
      (sound (id to))
    )
    (define-transition-sound (turn KP.|KP.L|KP.R|KS.|KS.L|KS.R|SH.|SH.L|SH.R|ST.|ST.L|ST.R pos continue)
      (sound (id on)))
    (define-transition-sound (turn KH.|KH.L|KH.R pos prepare|turn|past-turn)
      ;if hwy number is present, then say "to" -->and take exit 13B to I-5
      (if-hwy-exit ()
        (sound (id to)))
      ;if hwy number is not present, then say "and take" -->and take I-5
      (if-not-hwy-exit ()
        (sound (id and))
        (sound (id take))))
    (define-transition-sound (turn KP.|KP.L|KP.R|KS.|KS.L|KS.R pos prepare|turn|past-turn)
      (sound (id and-take)))
    (define-transition-sound (turn SH.|SH.L|SH.R|ST.|ST.L|ST.R pos prepare|turn|past-turn)
      (sound (id and-stay-on)))
    ; 
    ;Transition sounds for turns
    ; 
    (define-transition-sound (turn TR.HL|TR.HR|TR.L|TR.R|TR.SL|TR.SR|NR.R|NR.L pos continue)
      (sound (id on)))
    (define-transition-sound (turn TR.HL|TR.HR|TR.L|TR.R|TR.SL|TR.SR|NR.R|NR.L pos prepare|turn|past-turn)
      (sound (id on)))
    (define-transition-sound (turn NR. pos *)
      (sound (id on)))
    ; 
    ;Transition sounds for enter freeway
    ; 
    (define-transition-sound (turn EN.|EN.R|EN.L pos continue)
      (sound (id to)))
    (define-transition-sound (turn EN.|EN.R|EN.L pos prepare|turn|past-turn)
      (sound (id to)))
    ; 
    ;Transition sounds for enter ramp
    ; 
    (define-transition-sound (turn ER.R|ER.L|ER. pos *)
      (sound (id to)))
    ; 
    ;Transition sounds for pedestrian
    ; 
    (define-transition-sound (turn PE. pos continue)
      (sound (id on)))
    (define-transition-sound (turn PE. pos prepare|turn|past-turn)
	  (if-condition ()
        (expression()
           (and ()
              (value (key position-prepare))
			  (value (key dpronun-available))
            )
        )
        (then ()
          (if-dpronun-available ()
            (sound (id pause)))
        )
      )
      (sound (id to)))
    (define-transition-sound (turn ES.R|ES.L|ES.|EE.R|EE.L|EE. pos *)
      (sound (id on)))
    ; 
    ;Transition sounds for roundabouts
    ; 
    (define-transition-sound (turn RE. pos continue|turn)
      (sound (id on)))
    (define-transition-sound (turn RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10 pos continue|prepare|turn|past-turn)
      (sound (id on)))
    ; 
    ;Transition sounds for merge
    ; 
    (define-transition-sound (turn MR.L|MR.R pos continue|prepare|turn|past-turn)
      (sound (id onto)))
    ; 
    ;Transition sounds for bridge, tunnel and name change
    ; 
    (define-transition-sound (turn CO.|NC.|BE.R|BE.L|BE.|TE.R|TE.L|TE. pos *)
      (sound (id on)))
    ; 
    ;No transition sounds for the maneuvers below
    ; 
    (define-transition-sound (turn DT.|DT.L|DT.R|EC.|EC.L|EC.R|EX.|EX.L|EX.R|FE.|FX.|UT.|RT. pos continue))
    (define-transition-sound (turn DT.|DT.l|DT.R|EC.|EC.L|EC.R|EX.|EX.L|EX.R|FE.|FX.|RE.|UT.|RT. pos prepare))
    (define-transition-sound (turn DT.|DT.L|DT.R|EC.|EC.L|EC.R|EX.|EX.L|EX.R|FE.|FX.|UT.|RT. pos turn|past-turn)))
;
; Tone Mode Configuration
;
  (section (name tone)
; All prepare cases
    (instruction (turn * stacknext * pos prepare)
      (sound (id prepare-tone)))
; All turn cases
    (instruction (turn * stacknext * pos turn|past-turn)
      (sound (id turn-tone)))
; Traffic incident/congestion
    (instruction (turn TI.|TI.S stacknext * pos *) 
      (sound (id turn-tone))) 
    (instruction (turn TC.|TC.S stacknext * pos *) 
      (sound (id turn-tone))) 
; Recalc Case
    (instruction (pos recalc)
      (sound (id recalc-tone)))
; after Recalc and route update Case
    (instruction (pos recalc-update)
      (sound (id recalc-tone)))
; Soft Recalc Case
    (instruction (pos soft-recalc)
      (sound (id soft-recalc-tone)))
; Recalc Confirm Case
    (instruction (pos recalc-confirm)
      (sound (id recalc-confirm-tone)))
; Traffic Calc/Recalc Case
    (instruction (pos recalc-traffic)
      (sound (id recalc-tone)))
; Traffic Alert Case
    (instruction (pos traffic-alert)
      (sound (id turn-tone)))
; Route Calc Case
    (instruction (pos calc)
      (sound (id recalc-tone)))
; Speed limit Case
    (instruction (pos Speed-Limit-Zone)
      (sound (id speed-limit-tone)))
; School zone Case
    (instruction (pos School-Zone)
      (sound (id speed-limit-sz-tone))))

;
; Long Mode Voice Configuration (w/ Street Names)
;
  (section (name long)
;
; Continue Position Configuration
;
; RX.n instructions are not announced
    (instruction (turn RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10 stacknext * pos continue))
; RE uses the distance to the following RX.n instruction
    (instruction (turn RE. stacknext * pos continue)
	  (if-condition ()
	    (expression ()
          (value (key long-maneuver))
        )
        (then ()
          ;Announce stay
          (sound (id stay-on))
          (opronun ())
          (sound (id for-the-next))
          (rdistpronun ())
        )
        (else ()
          (sound (id in-about))
          ;get the distance to the following maneuver
          (next ()
            (rdistpronun ())
		  )
          ;Add pause
          (sound (id pause))
          ;take the nth exit at the roundabout | enter the roundabout toward your destination
          (turn-sound ())
          ;if not destination case
          (if (turn * stacknext * next RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10)
            (next ()
		      (if-dpronun-available ()
                ;on
                (transition-sound ())
                ; roundabout uses the next instruction (RX.n) for the destination
                (dpronun ())
			  )
			)
		  )
		)
	  )
	)

; CO. is only announced if dpronun() is available
(instruction (turn CO. stacknext * pos continue)
  (if-condition ()
    (expression ()
      (value (key long-maneuver))
    )
    (then ()
      ;Announce stay
      (sound (id stay-on))
      (opronun ())
      (sound (id for-the-next))
      (rdistpronun ())
    )
    (else ()
      (if-dpronun-available ()
        (if-not-unnamed ()
          (sound (id in-about))
          (rdistpronun ())
          ;Add pause
          (sound (id pause))
          (turn-sound ())
          (transition-sound ())
          (dpronun ())
		)
	  )
	)
  )
)

; General case
    (instruction (turn * stacknext * pos continue)
	  (if-condition ()
	    (expression ()
          (value (key long-maneuver))
        )
        (then ()
          ;Announce "stay" for maneuvers longer than 5 miles
          (sound (id stay-on))
          (opronun ())
          (sound (id for-the-next))
          (rdistpronun ())
        )
        (else ()
          (sound (id in-about))
          (rdistpronun ())
          ;Add pause
          (sound (id pause))
          ; The following  commands result in turn sound, transition sound and destination sound
          (if (turn MR.R|MR.L|KP.|KP.L|KP.R|TR.R|TR.L|TR.HR|TR.HL|TR.SL|TR.SR|KS.|KS.R|KS.L|ST.|ST.L|ST.R|SH.|SH.L|SH.R|EN.|EN.R|EN.L|NR.|PE.|NR.R|NR.L|BE.|BE.R|BE.L|TE.|TE.R|TE.L|ES.|ES.R|ES.L|EE.|EE.R|EE.L|ER.|ER.R|ER.L|NC. stacknext * next *)
            (turn-sound ())
            ;only play this part if the dpronun has been successfully loaded
            (if-dpronun-available ()
              (if-unnamed ()
                (sound (id toward))
                (if-next-named () 
                  (next-named ()
                    (dpronun-base ())
				  )
				)
                (if-not-next-named ()
                  (sound (id your-dest))
				)
			  )
              (if-not-unnamed ()
                (if-toward-name ()
                  (sound (id toward))
				)
                (if-not-toward-name ()
                  (transition-sound ())
				)
                (dpronun ())
			  )
			)
	      )
          ;In 5 and a half miles take the exit on the left to I-5
          (if (turn KH.|KH.R|KH.L stacknext * next *)
            (turn-sound ())
            (if-dpronun-available ()
              (transition-sound ())
              (dpronun ())
			)
		  )
          ; The following  commands result in turn sound only
          (if (turn DT.|DT.L|DT.R|EC.|EC.L|EC.R|FE.|FX.|EX.|EX.R|EX.L|UT.|RT. stacknext * next *)
            (turn-sound ())
		  )
		)
	  )
	)
; Special case for M1.
 (instruction (turn M1. stacknext * pos continue|prepare)
  (turn-sound ())
 )
; Special case for OR.
 (instruction (turn OR.|OR.L|OR.R stacknext * pos *)
  (turn-sound ())
 )
; Special case for EH., Head toward <major road name>
 (instruction (turn EH. stacknext * pos *)
  (sound (id head))
  (sound (id toward))
  (fmrpronun)
 )
 ; Special case for PO. Head toward the hightlighted route.
 (instruction (turn PO. stacknext * pos *)
  (sound (id head))
  (sound (id toward))
  (sound (id the-highlighted-route))
 )

; Prepare Position Configuration
;
; Merge: if continue was skipped, play the continue message, otherwise skip
;        if lookahead or button pressed play the message even if it already played
    (instruction (turn MR.R|MR.L stacknext * pos prepare)
      (if-condition ()
        (expression ()
          (or ()
            (not () (value (key continue-played)))
            (value (key lookahead))
            (value (key button-pressed))
          )
        )
        (then ()
          (sound (id in-about))
          (rdistpronun ())
          ;Add pause
          (sound (id pause))
          (turn-sound ())
          (if-dpronun-available ()
            (if-unnamed ()
              (sound (id toward))
              (if-next-named () 
                (next-named ()
                  (dpronun-base ())))
              (if-not-next-named ()
                (sound (id your-dest))))
            (if-not-unnamed ()
              (if-toward-name ()
                (sound (id toward)))
              (if-not-toward-name ()
                (transition-sound ()))
              (dpronun ())))
        )
      )
    )
; No prepare for exit ferry
    (instruction (turn FX. stacknext * pos prepare)
    ; nothing
    )
; Special case: roundabout uses the next instruction (RX.n) for the destination
    (instruction (turn RE. stacknext * pos prepare)
    (turn-sound ())
      (if (turn * stacknext * next RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10)
        ;dpronun comes from the next maneuver
        (next ()
        (if-dpronun-available ()
          ;on
          (transition-sound ())
          (dpronun ())))))
; Exit the roundabout (no longer used as it is now given as part of RE.)
    (instruction (turn RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10 stacknext * pos prepare)
    ; nothing
    )
; Enter country
    (instruction (turn EC.|EC.R|EC.L stacknext * pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (turn-sound ()))
; Continue straight through roundabout
    (instruction (turn RT. stacknext * pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (turn-sound ()))
; Destination
    (instruction (turn DT.|DT.R|DT.L stacknext * pos prepare)
      (turn-sound ()))
; U-Turn
    (instruction (turn UT. stacknext * pos prepare)
      (turn-sound ()))
; Enter Ferry
    (instruction (turn FE. stacknext * pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (turn-sound ()))
; Highway Exit
    (instruction (turn EX.|EX.R|EX.L stacknext * pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (turn-sound ()))
; CO. is only announced if dpronun() is available
(instruction (turn CO. stacknext * pos prepare)
  (if-dpronun-available ()
    (if-not-unnamed ()
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (turn-sound ())
      (transition-sound ())
      (dpronun ()))))

; General Case
    (instruction (turn * stacknext * pos prepare)
      (sound (id in-about))
      (rdistpronun ())
      ;Add pause
      (sound (id pause))
      (turn-sound ())
      (if-dpronun-available ()
        (if-unnamed ()
          (sound (id toward))
          (if-next-named () 
            (next-named ()
            (dpronun-base ())))
          (if-not-next-named ()
            (sound (id your-dest))))
        (if-not-unnamed ()
          (if-toward-name ()
            (sound (id toward)))
          (if-not-toward-name ()
            (transition-sound ()))
          (dpronun ()))))

;
; Turn Position Configuration
;
; RE. is now used to give the prepare for the exit
    (instruction (turn RE. stacknext * pos turn|past-turn)
      (turn-sound ())
      (if (turn * stacknext * next RX.1|RX.2|RX.3|RX.4|RX.5|RX.6|RX.7|RX.8|RX.9|RX.10)
        ;dpronun comes from the next maneuver
        (next ()
        (if-dpronun-available ()
          ;on
          (transition-sound ())
          (dpronun ())))))
; Special case, no dpronun and no stack for EC.*
    (instruction (turn EC.|EC.L|EC.R stacknext * pos turn|past-turn)
	  (turn-sound ()))
; Special Case - Merge (only do in lookahead, skip on regular)
    (instruction (turn MR.L|MR.R stacknext * pos turn|past-turn)
      (if-condition ()
        (expression ()
          ; if showing the lookahead or the user tapped on the screen
          (or ()
            (value (key lookahead))
            (value (key button-pressed))
          )
        )
        (then ()
          (turn-sound ())
          (if-dpronun-available ()
            (if-unnamed ()
              (sound (id toward))
              (if-next-named () 
                (next-named ()
                  (dpronun-base ())))
              (if-not-next-named ()
                (sound (id your-dest))))
            (if-not-unnamed ()
              (transition-sound ())
              (dpronun ())))
        )
        (else ()
          ;no automatic announcement for merge in turn position on nav view
        )
      )
    )
; Special Tunnel Case
    (instruction (turn TE.|TE.R|TE.L stacknext * pos turn|past-turn)
      (turn-sound ())
      (if-not-lookahead ()
        (if-stack() 
          (sound (id pause))
          (sound (id then))
          (sound (id in))
          (next-significant-dist ())
          (sound (id pause))
          (next-significant ()
            (if (turn !DT. stacknext * next *)
              (if (turn !DT.L stacknext * next *)
                (if (turn !DT.R stacknext * next *)
                  (turn-sound ()))))
            (if (turn DT.|DT.L|DR.R stacknext * next *)
              (turn-sound (pos continue)))
            (if (turn !EC. stacknext * next *)
              (if (turn !EC.L stacknext * next *)
                (if (turn !EC.R stacknext * next *)
                  (if (turn !EX. stacknext * next *)
                    (if (turn !EX.L stacknext * next *)
                      (if (turn !EX.R stacknext * next *)
                        (if (turn !DT. stacknext * next *)
                          (if (turn !DT.L stacknext * next *)
                            (if (turn !DT.R stacknext * next *)
                              (if-dpronun-available ()
                                (if-unnamed ()
                                  (sound (id towards))
                                  (if-next-named ()
                                    (next-named ()
                                      (dpronun-base ())))
                                  (if-not-next-named ()
                                    (sound (id your-dest))))
                                (if-not-unnamed ()
                                  (if-toward-name ()
                                    (sound (id towards)))
                                  (if-not-toward-name ()
                                    (transition-sound (pos turn)))
                                  (dpronun ())
                                  (if (turn * stacknext * next DT.|DT.R|DT.L)
                                    (sound (id towards))
                                    (sound (id your-dest))))))))))))))))))
; Turn sound without transition-dpronun part
    (instruction (turn FE.|UT.|EX.|EX.L|EX.R|FX.|RT. stacknext * pos turn|past-turn)
      (turn-sound ())
      ; stack sound is only given if not in the lookahead
      (if-condition ()
        (expression ()
          (and ()
            (value (key stack-advise))
            (not () (value (key lookahead)))
          )
        )
        (then ()
          ;skip stack sound for NC.|CO.|MR.L|MR.R|DT.|FX.|DT.L|DT.R
          (if (turn * stacknext !NC. next *)
            (if (turn * stacknext !CO. next *)
              (if (turn * stacknext !MR.L next *)
                (if (turn * stacknext !MR.R next *)
                  (if (turn * stacknext !DT.R next *)
                    (if (turn * stacknext * next !FX.)
                      (if (turn * stacknext !DT.L next *)
                        (if (turn * stacknext !DT. next *)
                          ;Add a pause
                          (sound (id pause))
                          (sound (id then))
                          (stack-sound (pos turn))))))))))
        )
        (else ()
          ;no stack sound
        )
      )
    )
; Destination Case
    (instruction (turn DT.|DT.R|DT.L stacknext * pos turn|past-turn)
      (turn-sound ()))
; Name Change Case
    (instruction (turn CO. stacknext * pos turn|past-turn)
        (if-dpronun-available ()
          (if-toward-name ()
            (sound (id continue))
            (sound (id toward)))
          (if-not-toward-name ()
            (sound (id continue-on)))
          (dpronun ())))
; Special Case - Speed cameras no pronoun - Turn SC.      
    (instruction (turn SC. stacknext * pos turn)
      (turn-sound ())
      (sound (id in))
      (speedcameraremaindist ()))        
; Special Case - Speeding alert no pronoun - Turn SC.S      
    (instruction (turn SC.S stacknext * pos turn)
      (turn-sound ()))
; General Case - skip stack for DT.*|MR.*|FX.|CO.|NC.
    (instruction (turn * stacknext * pos turn|past-turn)
      (turn-sound ())
      (if-dpronun-available ()
        (if-unnamed ()
          (sound (id toward))
          (if-next-named () 
            (next-named ()
              (dpronun-base ())))
          (if-not-next-named ()
            (sound (id your-dest))))
        (if-not-unnamed ()
          (if-toward-name ()
            (sound (id toward)))
          (if-not-toward-name ()
		    (sound (id pause))
            (transition-sound ()))
          (dpronun ())))
      ; stack sound is only given if not in the lookahead
      (if-condition ()
        (expression ()
          (and ()
            (value (key stack-advise))
            (not () (value (key lookahead)))
          )
        )
        (then ()
          ;skip stack sound for NC.|CO.|MR.L|MR.R|DT.|FX.|DT.L|DT.R
          (if (turn * stacknext !NC. next *)
            (if (turn * stacknext !CO. next *)
              (if (turn * stacknext !MR.L next *)
                (if (turn * stacknext !MR.R next *)
                  (if (turn * stacknext !DT.R next *)
                    (if (turn * stacknext * next !FX.)
                      (if (turn * stacknext !DT.L next *)
                        (if (turn * stacknext !DT. next *)
                          ;Add a pause
                          (sound (id pause))
                          (sound (id then))
                          (stack-sound (pos turn))))))))))
        )
        (else ()
          ;no stack sound
        )
      )
    )
;
; Recalc Configurations
;
    (instruction (pos recalc)
      (sound (id recalc-tone)))
; after Recalc and route update Case
    (instruction (pos recalc-update)
      (sound (id recalc)))
; Soft Recalc Case
    (instruction (pos soft-recalc)
      (sound (id soft-recalc-tone)))
; Recalc Confirm Case
    (instruction (pos recalc-confirm)
      (sound (id recalc-confirm-tone)))
; Traffic Calc/Recalc Case
    (instruction (pos recalc-traffic)
      (sound (id getting-traffic)))
; Route Calc Case
    (instruction (pos calc)
      (sound (id getting-route)))     
; Traffic Alert Case
    (instruction (pos traffic-alert)
      (sound (id traffic-update))
      (expect-traffic ())
      (if-traffic-delay-threshold ()
        (traffic-delay ())
        (sound (id delay))))
; Traffic Delay Case
    (instruction (pos traffic-delay)
      (expect-traffic ())
      (if-traffic-delay-threshold ()
        (traffic-delay ())
        (sound (id delay)))))      


; Traffic Warnings
  (section (name traffic)
    (instruction (turn TI.|TI.S stacknext * pos *)
      ;a traffic incident has been reported in about 3 miles on I-5 [at Main]
      (turn-sound ())
      (sound (id in-about))
      (trafficincidentdist ())
      ;Add pause
      (sound (id pause))
      (if-ti-road-pronun ()
        (sound (id on))
        (ti-road-pronun ())
        (if-ti-origin-pronun ()
          (ti-origin-proximity ())
          (ti-origin-pronun ()))))
    (instruction (turn TC.|TC.S stacknext * pos *)
      (if-not-in-congestion ()
        ;traffic congestion in about 3 miles on I-5
        (turn-sound ())
        (sound (id in-about))
        (trafficcongestiondist ())
        ;Add pause
        (sound (id pause))
        (if-tc-road-pronun ()
          ;on I-5
          (sound (id on))
          (tc-road-pronun ())))
      (if-in-congestion ()
        ;traffic congestion
        (turn-sound ())
        ;for the next 5 miles
        (sound (id for-about))
        (trafficcongestionlen ()))))

; Speed limit Warnings
  (section (name speed-limit)
    (instruction (pos *)
      (sound (id speed-limit-tone)))
 ; Speed limit Case
    (instruction (pos Speed-Limit-Zone)
      (sound (id speed-limit-tone)))
; School zone Case
    (instruction (pos School-Zone)
      (sound (id speed-limit-sz-tone)))))
