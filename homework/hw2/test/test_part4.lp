let bonus = 0 in
fun tt with x,y = x in
fun ff with x,y = y in
fun neg with b = b ff tt in
fun and with b1, b2 = bonus in
fun or with b1, b2 = bonus in
fun xor with b1, b2 = bonus in
fun imply with b1, b2 = bonus in
fun to_int with b = b 1 0 in

to_int  (
neg tt
// and tt ff
// or tt ff
// xor tt ff
// imply tt ff
)