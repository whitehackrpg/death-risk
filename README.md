# death-risk
Calculate the risk of your character dying from an attack in Whitehack RPG. It's a quick and ugly prototype that hasn't been proofed for correctness, so take the outcomes with a grain of salt for now.

```
(load "~/death-risk.lisp")
(make-sit :av 11 :df 1 :hp 1 :dammod 1 :save 11)
(death-risk *)
==>
(STILL-IN-ACTION 60.55)
(JUST-KNOCKED-OUT 4.3)
(ALSO-INJURED 21.9)
(DEAD 13.24)
```
There is roughly 13% risk of dying for a Tgh 11 character with 1 HP and wearing cloth armor, if attacked by a HD 1 enemy using a sword. Call `death-risk` with `:damsides 10` to check against an attack based on a d10 damage die. Call it with `:no-save t` to see the risk when you have already used your save vs. damage. There are some extra posts in the situation struct that you can give as well, to handle double rolls and boss fights. See the definition of the struct in the code.
