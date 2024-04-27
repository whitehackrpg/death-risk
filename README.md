# death-risk
Calculate the risk of your character dying from an attack in Whitehack RPG. 

```
(load "~/death-risk.lisp")
(make-sit :av 11 :df 1 :hp 1 :dammod 1 :save 11)
(death-risk *)
==>
(STILL-IN-ACTION 50.0)
(KNOCKED-OUT 11.3)
(INJURED 25.5)
(DEAD 13.2)
```
There is roughly 13% risk of dying for a Tgh 11 character with 1 HP and wearing cloth armor, if attacked by a HD 1 enemy using a sword. Call `death-risk` with `:damsides 10` to check against an attack based on a d10 damage die. Call it with `:no-save t` to see the risk when you have already used your save vs. damage.
