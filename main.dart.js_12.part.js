((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,A={ahn:function ahn(d){this.a=d},aho:function aho(d){this.a=d},
aZr(){var w=B.b([],x.r),v=$.cx,u=(v==null?$.cx=$.fu():v).fi("[DEFAULT]")
B.cI(u,$.f_(),!0)
v=B.u7(new B.ec(u))
v=new B.ais(v)
return new A.jl(v,w,$.as())},
jl:function jl(d,e,f){var _=this
_.a=d
_.c=_.b=null
_.d=!1
_.e=e
_.r=_.f=!1
_.K$=0
_.U$=f
_.al$=_.ai$=0},
apT:function apT(d,e){this.a=d
this.b=e},
apU:function apU(d,e){this.a=d
this.b=e},
a4a:function a4a(){},
VG:function VG(){},
apD:function apD(){},
apE:function apE(d,e,f){var _=this
_.as=d
_.a=null
_.b=e
_.d=$
_.e=null
_.f=f},
apJ:function apJ(){},
apK:function apK(d,e,f){this.a=d
this.b=e
this.c=f},
apL:function apL(d,e){this.a=d
this.b=e},
apM:function apM(d,e){this.a=d
this.b=e},
apF:function apF(){},
apG:function apG(d,e,f){this.a=d
this.b=e
this.c=f},
apH:function apH(d,e){this.a=d
this.b=e},
apI:function apI(d,e){this.a=d
this.b=e},
apN:function apN(d){this.a=d},
apO:function apO(d){this.a=d},
apP:function apP(d){this.a=d},
ayt:function ayt(d,e,f,g,h){var _=this
_.e=_.d=_.c=_.b=_.a=null
_.f=!1
_.x=_.w=_.r=null
_.z=d
_.Q=$
_.as=e
_.at=null
_.ay=$
_.ch=f
_.CW=g
_.cx=!1
_.cy=h},
apC:function apC(d,e,f){var _=this
_.a=d
_.b=1883
_.c=e
_.d=!1
_.as=_.Q=_.z=_.y=null
_.at=0
_.ay=null
_.ch=f
_.k1=_.cx=_.CW=null},
bbO(d){var w,v
for(w=d.length,v=0;v<w;++v)if(d.charCodeAt(v)>127)throw B.f(B.ci("mqtt_client::MQTTEncoding: The input string has extended UTF characters, which are not supported"))},
aX0(d){var w=new A.Si()
w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation."
if(d!=null)w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation. Current state is "+d.H().split(".")[1]
return w},
alk(d){var w=new A.UN()
w.a="mqtt-client::InvalidHeaderException: "+d
return w},
aYG(d){var w=new A.UO()
w.a="mqtt-client::InvalidMessageException: "+d
return w},
va(d){var w=new A.W8()
w.a="mqtt-client::NoConnectionException: "+d
return w},
zx(d,e){var w=d.a
if((w.c&4)===0)w.t(0,e)
else A.aA(y.a,!1)},
aZt(d,e){if((d.c&4)!==0){A.aA("Guarded add - stream is closed - event not added",!1)
return}if(d.d==null)A.aA("Guarded add - stream has no listeners - adding anyway",!1)
d.t(0,e)},
aZp(){var w=new A.Hi(),v=new A.iE(C.aU)
v.a=C.mU
w.a=v
v=A.aSw()
w.b=v
A.aSw()
w.c=new A.VJ(v)
return w},
aSw(){var w=new A.VK(C.aO,new A.e0())
w.hM()
return w},
bbQ(d){var w,v=new A.fL(new Uint8Array(0),0),u=0
do{w=d.h7()
v.ow(w);++u}while(u<=4&&(w&128)===128)
return v},
bbP(d){var w,v,u,t,s
for(w=B.l(d),v=new B.bR(d,d.gE(0),w.j("bR<aU.E>")),w=w.j("aU.E"),u=0,t=1;v.v();){s=v.d
u+=((s==null?w.a(s):s)&127)*t
t*=128}return u},
bbS(d){var w,v,u,t,s,r
try{w=new A.iE(C.aU)
t=new A.iE(C.aU)
t.is(d)
w=t
if(d.a.b-d.b<w.e){d.b=0
s=A.aYG("Available bytes is less than the message size")
throw B.f(s)}s=A.bbR(w,d)
return s}catch(r){s=B.a0(r)
if(x.L.b(s)){v=s
u=B.ak(r)
B.fW(A.aYG("The data provided in the message stream was not a valid MQTT Message, exception is "+B.k(v)),u)}else throw r}},
bbR(d,e){var w,v,u,t
switch(d.a){case C.mU:w=new A.Hi()
w.a=d
v=new A.VK(C.aO,new A.e0())
v.is(e)
w.b=v
A.aSw()
u=new A.VJ(v)
u.sDg(A.qB(e))
t=v.d
t===$&&B.a()
if(t.c){u.b=A.qB(e)
u.c=A.qB(e)}if(v.d.r){t=D.c.f_(A.qB(e))
u.d=t}if(v.d.f){v=D.c.f_(A.qB(e))
u.f=v}w.c=u
break
case C.mX:w=new A.Hh()
w.a=d
w.SG(e)
v=new A.apR(C.aO,new A.e0())
v.is(e)
w.b=v
break
case C.jd:w=new A.v5()
w.a=d
w.SG(e)
v=new A.VT(w.a,C.aO,new A.e0())
v.hM()
v.is(e)
w.b=v
u=w.a
t=new A.VQ(u,v)
t.c=e.aIV(u.e-v.a)
w.c=t
break
case C.je:w=new A.zy()
w.a=d
v=new A.VO(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
break
case C.jh:w=new A.zz()
w.a=d
v=new A.VP(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
break
case C.jf:w=new A.zA()
w.a=d
v=new A.VR(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
break
case C.jg:w=new A.zB()
w.a=d
v=new A.VS(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
break
case C.mY:w=new A.Ho()
w.a=d
d.c=C.bL
v=new A.VV(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
v=new A.VU(v,d,B.o(x.T,x.n))
v.is(e)
w.c=v
break
case C.mZ:w=new A.Hn()
w.a=d
v=new A.apW(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
v=new A.apV(v,d,B.b([],x.v))
v.is(e)
w.c=v
break
case C.yu:w=new A.VW()
w.a=d
v=new A.aq1(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
v=new A.aq0(v,d,B.b([],x.s))
v.is(e)
w.c=v
break
case C.mV:w=new A.Hp()
w.a=d
v=new A.aq_(C.aO,new A.e0())
v.hM()
v.nz(e)
w.b=v
break
case C.jb:w=new A.Hl()
w.a=d
break
case C.jc:w=new A.Hm()
w.a=d
break
case C.mW:w=new A.Hj()
w.a=d
break
default:throw B.f(A.alk("The Message Type specified ("+d.k(0)+".messageType) is not a valid MQTT Message type or currently not supported."))}return w},
aZs(d){var w,v,u,t
for(w=B.l(d),v=new B.bR(d,d.gE(0),w.j("bR<aU.E>")),w=w.j("aU.E"),u="";v.v();u=t){t=v.d
if(t==null)t=w.a(t)
t=u+"<"+B.k(t)+">"}return u.charCodeAt(0)==0?u:u},
bbT(d){var w,v
try{w=D.an.fk(d.eo(d))
return w}catch(v){return""}},
aZu(){var w=new A.Ho(),v=new A.iE(C.aU)
v.a=C.mY
w.a=v
v.c=C.bL
v=new A.VV(C.aO,new A.e0())
v.hM()
w.b=v
w.c=new A.VU(null,null,B.o(x.T,x.n))
return w},
aSW(d){var w=new A.Xh(d)
w.Th(d,B.b([A.b3U(),A.b3T(),A.blm()],x.x))
return w},
bd2(d){var w=d.a
if(D.c.p(w,"#")||D.c.p(w,"+"))throw B.f(B.ci("mqtt_client::PublicationTopic: Cannot publish to a topic that contains MQTT topic wildcards (# or +)"))},
aTf(){var w=x.y
return new A.B_(B.b([],w),B.b([],x.p),B.b([],w),C.n_,A.aTg("rawtopic"),new A.Ry(x.Q))},
aTg(d){var w=new A.Zn(d)
w.Th(d,B.b([A.b3U(),A.b3T(),A.blo(),A.bln()],x.x))
return w},
bel(d){var w=d.a
if(D.c.p(w,"#")&&!D.c.n7(w,"#"))throw B.f(B.ci("mqtt_client::SubscriptionTopic: The rawTopic wildcard # can only be present at the end of a topic"))
if(w.length>1&&D.c.n7(w,"#")&&!D.c.n7(w,"/#"))throw B.f(B.ci("mqtt_client::SubscriptionTopic: Topics using the # wildcard longer than 1 character must be immediately preceeded by a the rawTopic separator /"))},
bek(d){var w=d.b
w===$&&B.a()
if(D.b.ed(w,new A.ayo()))throw B.f(B.ci("mqtt_client::SubscriptionTopic: rawTopic Fragment contains a wildcard but is more than one character long"))},
beZ(d){var w=d.a.length
if(w>65535)throw B.f(B.ci("mqtt_client::Topic: The length of the supplied rawTopic ("+w+") is longer than the maximum allowable (65535)"))},
bf_(d){if(d.a.length===0)throw B.f(B.ci("mqtt_client::Topic: rawTopic must contain at least one character"))},
qC(d,e){d.jI(new A.e0().ls(e))},
qB(d){var w,v=d.ny(2)
if(v.b<2)B.S(B.ci("mqtt_client::MQTTEncoding: Length byte array must comprise 2 bytes"))
w=d.ny((v.ga2(v)<<8>>>0)+v.i(0,1))
return D.dX.bN(w.eo(w))},
aA(d,e){},
aq2(d){switch(d){case 0:return C.aU
case 1:return C.bL
case 2:return C.eD
case 128:return C.n_
default:return C.SV}},
Hk:function Hk(d,e){this.a=d
this.b=e},
zw:function zw(d,e){this.a=d
this.b=e},
VL:function VL(){},
VM:function VM(){},
VN:function VN(){var _=this
_.a=$
_.b=0
_.f=_.e=_.d=_.c=null
_.w=_.r=0
_.x=null
_.y=$
_.z=!1
_.as=_.Q=0},
e0:function e0(){},
RZ:function RZ(){this.a=$},
Si:function Si(){this.a=$},
UE:function UE(){this.a=$},
UN:function UN(){this.a=$},
UO:function UO(){this.a=$},
UP:function UP(){this.a=$},
W8:function W8(){this.a=$},
VI:function VI(d){var _=this
_.c=_.b=_.a=!1
_.d=d
_.r=_.f=_.e=!1},
Hi:function Hi(){this.b=null
this.c=$
this.a=null},
VJ:function VJ(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.e=""
_.f=null},
mB:function mB(d,e){this.a=d
this.b=e},
VK:function VK(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hh:function Hh(){this.b=$
this.a=null},
apR:function apR(d,e){var _=this
_.y=!1
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hj:function Hj(){this.a=null},
iE:function iE(d){var _=this
_.a=null
_.b=!1
_.c=d
_.d=!1
_.e=0},
dD:function dD(){},
fm:function fm(d,e){this.a=d
this.b=e},
apS:function apS(){},
aq3:function aq3(){},
Hl:function Hl(){this.a=null},
Hm:function Hm(){this.a=null},
v5:function v5(){this.b=null
this.c=$
this.a=null},
VQ:function VQ(d,e){this.a=d
this.b=e
this.c=$},
VT:function VT(d,e,f){var _=this
_.y=d
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=e
_.r=""
_.w=0
_.x=f},
zy:function zy(){this.b=$
this.a=null},
VO:function VO(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zz:function zz(){this.b=$
this.a=null},
VP:function VP(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zA:function zA(){this.b=$
this.a=null},
VR:function VR(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zB:function zB(){this.b=$
this.a=null},
VS:function VS(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Ho:function Ho(){var _=this
_.b=null
_.c=$
_.a=_.d=null},
VU:function VU(d,e,f){this.a=d
this.b=e
this.c=f},
apZ:function apZ(d){this.a=d},
apX:function apX(d,e){this.a=d
this.b=e},
apY:function apY(d){this.a=d},
VV:function VV(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hn:function Hn(){this.b=null
this.c=$
this.a=null},
apV:function apV(d,e,f){this.a=d
this.b=e
this.c=f},
apW:function apW(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
VW:function VW(){this.b=null
this.c=$
this.a=null},
aq0:function aq0(d,e,f){this.a=d
this.b=e
this.c=f},
aq1:function aq1(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hp:function Hp(){this.b=$
this.a=null},
aq_:function aq_(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hg:function Hg(){},
k7:function k7(d,e,f){this.a=d
this.b=e
this.c=f},
zr:function zr(d){this.a=d},
y6:function y6(d){this.a=d},
qy:function qy(d,e){this.a=d
this.b=e},
xx:function xx(){},
Au:function Au(d){this.a=d},
yo:function yo(){},
yn:function yn(){},
ap_:function ap_(){this.a=0},
l4:function l4(d,e){this.a=d
this.b=e},
ok:function ok(d,e){this.b=d
this.$ti=e},
Xh:function Xh(d){this.a=d
this.b=$},
Xi:function Xi(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=!1
_.x=j
_.y=k},
B_:function B_(d,e,f,g,h,i){var _=this
_.b=null
_.c=!1
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i},
ayp:function ayp(){},
ayq:function ayq(){},
Zn:function Zn(d){this.a=d
this.b=$},
ayo:function ayo(){},
Zo:function Zo(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.x=_.w=_.r=null
_.y=!0
_.z=i
_.Q=j},
oY:function oY(){},
zv:function zv(d){this.a=d
this.b=0},
apQ:function apQ(){this.a=null},
VH:function VH(d){var _=this
_.a=d
_.c=_.b=$
_.d=!1},
Ry:function Ry(d){this.$ti=d},
We:function We(){},
Eh:function Eh(){},
Bg:function Bg(){},
a3n:function a3n(){},
fL:function fL(d,e){this.a=d
this.b=e}},C,E
J=c[1]
B=c[0]
D=c[2]
A=a.updateHolder(c[7],A)
C=c[29]
E=c[16]
A.ahn.prototype={
ra(d){var w,v=this.a,u=B.l(v)
if(B.cA(d)===C.a5b)return d.j("c2<0>").a(new B.cs(v,u.j("cs<1>")))
else{u=u.j("cs<1>")
w=u.j("Pl<c2.T>")
return new B.Eg(new B.Pl(new A.aho(d),new B.cs(v,u),w),w.j("@<c2.T>").aH(d).j("Eg<1,2>"))}}}
A.jl.prototype={
gF2(){return this.f},
gaFJ(){return this.r},
ET(d){return this.aEZ(d)},
aEZ(a0){var w=0,v=B.L(x.H),u,t=2,s=[],r=[],q=this,p,o,n,m,l,k,j,i,h,g,f,e,d
var $async$ET=B.G(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:if(q.f||q.r){w=1
break}q.r=!0
D.b.M(q.e)
if(!q.d)q.aG()
l="flutter_"+a0+"_"+Date.now()
k="inbody/users/"+a0
p=k+"/data"
o=k+"/status"
k=q.b
if(k==null){j=new A.apC("wss://broker.emqx.io/mqtt",l,new A.k7(C.cj,C.cD,C.eC))
j.b=8084
j.z=C.Qj
q.b=j
k=j}k.at=20
i=A.aZp()
k=i.c
k===$&&B.a()
k.sDg(l)
k=i.b.d
k===$&&B.a()
k.b=!0
k.c=!0
h=i.c
h.b=o
h.c="offline"
k.d=C.bL
k.e=!0
q.b.sMY(i)
k=q.b
k.cx=new A.apT(q,a0)
t=4
w=7
return B.E(k.Dk(),$async$ET)
case 7:q.f=!0
k=q.b
h=p
if(k.ga2q().a!==C.c0){g=k.y
B.S(A.aX0(g==null?null:g.cy.a))}k=k.Q
if(k.aKn(h)==null)k.a2M(h,C.bL)
B.k(p)
f=new A.apQ()
f.a=new A.fL(new Uint8Array(0),0)
n=f
n.axp("online")
k=q.b
k.toString
k.aIv(o,C.bL,n.a,!0)
k=q.c
if(k!=null)k.aB()
k=q.b.Q
if(k==null)k=null
else{k=k.Q
k=x.P.a(new B.cs(k,B.l(k).j("cs<1>")))}q.c=k.e7(new A.apU(q,a0))
r.push(6)
w=5
break
case 4:t=3
d=s.pop()
m=B.a0(d)
q.f=!1
r.push(6)
w=5
break
case 3:r=[2]
case 5:t=2
q.r=!1
if(!q.d)q.aG()
w=r.pop()
break
case 6:case 1:return B.J(u,v)
case 2:return B.I(s.at(-1),v)}})
return B.K($async$ET,v)},
Br(d,e){return this.amP(d,e)},
amP(d,e){var w=0,v=B.L(x.H),u=1,t=[],s=this,r,q,p,o,n
var $async$Br=B.G(function(f,g){if(f===1){t.push(g)
w=u}for(;;)switch(w){case 0:u=3
r=D.e8.a2T(d,null)
q=E.aYB("mqtt_"+Date.now(),r)
D.b.e4(s.e,0,q)
if(!s.d)s.aG()
w=6
return B.E(s.a.CN(e,q),$async$Br)
case 6:u=1
w=5
break
case 3:u=2
n=t.pop()
p=B.a0(n)
w=5
break
case 2:w=1
break
case 5:return B.J(null,v)
case 1:return B.I(t.at(-1),v)}})
return B.K($async$Br,v)},
aBn(){var w=this,v=w.c
if(v!=null)v.aB()
w.c=null
v=w.b
if(v!=null)v.J_(!1)
w.f=!1
if(!w.d)w.aG()},
m(){var w,v=this
v.d=!0
w=v.c
if(w!=null)w.aB()
w=v.b
if(w!=null)w.J_(!1)
v.dC()},
$ia9:1}
A.a4a.prototype={}
A.VG.prototype={
pj(d){var w,v,u,t,s,r,q,p,o,n=this,m=y.a
A.aA("MqttBrowserConnection::_onData",!1)
u=J.dK(d,0,null)
if(u.length===0){A.aA("MqttBrowserConnection::_ondata - Error - 0 byte message",!1)
return}t=n.d
t===$&&B.a()
t.a.O(0,u)
for(t=x.L,s=n.f;r=n.d,r.aFL();){w=!0
v=null
try{v=A.bbS(r)}catch(q){if(t.b(B.a0(q))){A.aA("MqttBrowserConnection::_ondata - message is not yet valid, waiting for more data ...",!1)
w=!1}else throw q}if(!w){n.d.b=0
return}if(w){r=n.d
p=r.b
o=r.a
if(p<o.b){B.dE(0,p,o.gE(0),null,null)
if(p>0)o.Ip(o,0,p)}else o.sE(0,0)
r.b=0
A.aA("MqttBrowserConnection::_onData - message received ",v)
if(v.a.a===C.mX){r=v
p=s.a
if((p.c&4)===0){if(!p.gmM())B.S(p.mD())
p.lL(new A.y6(r))}else A.aA(m,!1)}else{r=v
p=s.a
if((p.c&4)===0){if(!p.gmM())B.S(p.mD())
p.lL(new A.zr(r))}else A.aA(m,!1)}A.aA("MqttBrowserConnection::_onData - message available event fired",!1)}else A.aA("MqttBrowserConnection::_onData - WARN - message available event not fired, event bus is closed",!1)}},
a_x(){var w,v,u
this.vC()
A.aA("MqttBrowserConnection::_startListening",!1)
try{this.aHt()}catch(v){u=B.a0(v)
if(x.L.b(u)){w=u
A.aA("MqttBrowserConnection::_startListening - exception raised "+B.k(w),!1)}else throw v}}}
A.apD.prototype={}
A.apE.prototype={
xx(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b2(new B.ab($.ah,x.w),x.l)
A.aA("MqttBrowserWsConnection::connect - entered",!1)
w=null
try{w=B.kn(d)}catch(p){if(x.L.b(B.a0(p))){v=B.ak(p)
u="MqttBrowserWsConnection::connect - The URI supplied for the WS connection is not valid - "+d
B.fW(A.va(u),v)}else throw p}if(w.gjM()!=="ws"&&w.gjM()!=="wss")throw B.f(A.va("MqttBrowserWsConnection::connect - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.Q6(e)
t=w.gqg()
A.aA("MqttBrowserWsConnection::connect -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a1<1,h>")
m=B.V(new B.a1(m,new A.apJ(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.zv(new A.fL(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kv(s,"open",new A.apK(o,k,j),!1,n)
o.b=B.kv(s,"close",new A.apL(o,j),!1,n)
o.a=B.kv(s,"error",new A.apM(o,j),!1,n)}catch(p){if(x.L.b(B.a0(p))){r=B.ak(p)
q="MqttBrowserWsConnection::connect - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fW(A.va(q),r)}else throw p}A.aA("MqttBrowserWsConnection::connect - connection is waiting",!1)
return j.a},
azk(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b2(new B.ab($.ah,x.w),x.l)
A.aA("MqttBrowserWsConnection::connectAuto - entered",!1)
w=null
try{w=B.kn(d)}catch(p){if(x.L.b(B.a0(p))){v=B.ak(p)
u="MqttBrowserWsConnection::connectAuto - The URI supplied for the WS connection is not valid - "+d
B.fW(A.va(u),v)}else throw p}if(w.gjM()!=="ws"&&w.gjM()!=="wss")throw B.f(A.va("MqttBrowserWsConnection::connectAuto - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.Q6(e)
t=w.gqg()
A.aA("MqttBrowserWsConnection::connectAuto -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a1<1,h>")
m=B.V(new B.a1(m,new A.apF(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.zv(new A.fL(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kv(s,"open",new A.apG(o,k,j),!1,n)
o.b=B.kv(s,"close",new A.apH(o,j),!1,n)
o.a=B.kv(s,"error",new A.apI(o,j),!1,n)}catch(p){if(x.L.b(B.a0(p))){r=B.ak(p)
q="MqttBrowserWsConnection::connectAuto - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fW(A.va(q),r)}else throw p}A.aA("MqttBrowserWsConnection::connectAuto - connection is waiting",!1)
return j.a},
vC(){var w,v,u
for(w=this.b,v=w.length,u=0;u<w.length;w.length===v||(0,B.y)(w),++u)w[u].aB()
D.b.M(w)},
Dh(){var w=this.a
if(w!=null)w.close()},
aHt(){var w,v=this,u=v.a
if(u==null)throw B.f(B.ax("webSocket is null"))
w=x.m
return B.b([B.kv(u,"close",new A.apN(v),!1,w),B.kv(u,"message",new A.apO(v),!1,w),B.kv(u,"error",new A.apP(v),!1,w)],x.d)}}
A.ayt.prototype={
us(d,e,f){return this.aFh(d,e,f)},
aFh(d,e,a0){var w=0,v=B.L(x.e),u,t=2,s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f
var $async$us=B.G(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect entered",!1)
q=x.L
p=r.as
o=x.d
n=x.g
m=x.Y
l=r.z
k=0
case 3:A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect - initiating connection try "+k+", auto reconnect in progress "+r.f,!1)
j=r.cy
j.a=C.yt
j.b=C.cD
if(!r.f){i=new A.apE(C.PB,B.b([],o),p)
h=r.at
if(h!=null)i.as=h
i.e=r.b
r.ay=i}t=7
w=!r.f?10:12
break
case 10:A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connect",!1)
j=r.ay
j===$&&B.a()
w=13
return B.E(j.xx(d,e),$async$us)
case 13:w=11
break
case 12:A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connectAuto",!1)
j=r.ay
j===$&&B.a()
w=14
return B.E(j.azk(d,e),$async$us)
case 14:case 11:t=2
w=9
break
case 7:t=6
f=s.pop()
if(q.b(B.a0(f)))if(r.f)A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect exception thrown during auto reconnect - ignoring",!1)
else throw f
else throw f
w=9
break
case 6:w=2
break
case 9:A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect - connection complete",!1)
A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect sending connect message",!1)
r.kI(a0)
A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect - pre sleep, state = "+r.cy.k(0),!1)
j=r.Q
j===$&&B.a()
if(!j.d){j.b=new B.b2(new B.ab($.ah,n),m)
j.c=B.cg(B.eb(0,j.a,0),j.gavC())
j.d=!0}j=j.b
j===$&&B.a()
w=15
return B.E(j.a,$async$us)
case 15:++k
A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect - post sleep, state = "+r.cy.k(0),!1)
if(r.cy.a!==C.c0)if(!r.f)A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect failed, attempt "+k,!1)
j=r.cy.a!==C.c0
case 4:if(j&&k<l){w=3
break}case 5:if(j)if(!r.f){A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect failed",!1)
q=r.cy.b
l="The maximum allowed connection attempts ({"+l
if(q===C.cD)throw B.f(A.va(l+"}) were exceeded. The broker is not responding to the connection request message (Missing Connection Acknowledgement?"))
else throw B.f(A.va(l+"}) were exceeded. The broker is not responding to the connection request message correctly The return code is "+B.k(q)))}A.aA("SynchronousMqttBrowserConnectionHandler::internalConnect exited with state "+r.cy.k(0),!1)
r.cx=!0
u=r.cy
w=1
break
case 1:return B.J(u,v)
case 2:return B.I(s.at(-1),v)}})
return B.K($async$us,v)}}
A.apC.prototype={
Dk(){var w=0,v=B.L(x.F),u,t=this,s,r,q
var $async$Dk=B.G(function(d,e){if(d===1)return B.I(e,v)
for(;;)switch(w){case 0:t.d=$.aZo=!0
s=new A.ahn(new B.er(null,null,x.J))
t.k1=s
s.ra(x.u).e7(t.gaBq())
r=t.k1
if(r!=null)r.ra(x.o).e7(t.gaBo())
r=t.k1
q=new A.ayt(3,r,B.o(x.q,x.i),B.b([],x.B),new A.k7(C.cj,C.cD,C.eC))
q.Q=new A.VH(5000)
r.ra(x.h).e7(q.gay_())
r.ra(x.W).e7(q.gaGI())
r.ra(x._).e7(q.gazi())
t.y=q
w=3
return B.E(t.abb(null,null),$async$Dk)
case 3:u=e
w=1
break
case 1:return B.J(u,v)}})
return B.K($async$Dk,v)}}
A.Hk.prototype={
H(){return"MqttDisconnectionOrigin."+this.b}}
A.zw.prototype={
H(){return"MqttConnectionState."+this.b}}
A.VL.prototype={
Pp(){var w=this
w.vC()
w.Dh()
w.a=null
if(w.e!=null){A.aA("MqttConnectionBase::_onDone - calling disconnected callback",!1)
w.e.$0()}}}
A.VM.prototype={
xy(d,e,f){return this.azg(d,e,f)},
azg(d,e,f){var w=0,v=B.L(x.e),u,t=2,s=[],r=this,q,p,o
var $async$xy=B.G(function(g,h){if(g===1){s.push(h)
w=t}for(;;)switch(w){case 0:r.r=d
r.w=e
A.aA("MqttConnectionHandlerBase::connect - server "+d+", port "+e,!1)
r.x=f
t=4
w=7
return B.E(r.us(d,e,f),$async$xy)
case 7:q=r.cy
u=q
w=1
break
t=2
w=6
break
case 4:t=3
o=s.pop()
if(x.L.b(B.a0(o))){r.cy.a=C.SQ
throw o}else throw o
w=6
break
case 3:w=2
break
case 6:case 1:return B.J(u,v)
case 2:return B.I(s.at(-1),v)}})
return B.K($async$xy,v)},
D3(d){return this.ay0(d)},
ay0(d){var w=0,v=B.L(x.H),u,t=this,s,r
var $async$D3=B.G(function(e,f){if(e===1)return B.I(f,v)
for(;;)switch(w){case 0:A.aA("MqttConnectionHandlerBase::autoReconnect entered",!1)
s=t.f
if(s){w=1
break}t.f=!0
s=t.ay
s===$&&B.a()
s.vC()
s.Dh()
s.a=null
t.ay.e=null
A.aA("MqttConnectionHandlerBase::autoReconnect - attempting reconnection",!1)
s=t.r
s.toString
r=t.w
r.toString
w=3
return B.E(t.xy(s,r,t.x),$async$D3)
case 3:r=f
t.cy=r
t.f=!1
s=t.as
if(r.a===C.c0){t.ay.e=t.b
s.toString
A.zx(s,new A.Au(!0))
A.aA("MqttConnectionHandlerBase::autoReconnect - auto reconnect complete",!1)}else{A.aA("MqttConnectionHandlerBase::autoReconnect - auto reconnect failed - re trying",!1)
s.toString
A.zx(s,new A.xx())}case 1:return B.J(u,v)}})
return B.K($async$D3,v)},
kI(d){var w,v,u,t,s
A.aA("MqttConnectionHandlerBase::sendMessage",!1)
w=this.cy.a
if(w===C.c0||w===C.yt){v=new A.zv(new A.fL(new Uint8Array(0),0))
d.i7(v)
w=v.a.b
if(0<=w)v.b=0
else v.b=w
A.aA("MqttConnectionHandlerBase::sendMessage = message is "+d.k(0),!1)
w=this.ay
w===$&&B.a()
u=J.td(D.l.gbe(v.ny(v.a.b).a),0,null)
w=w.a
if(w!=null){t=B.a6(u)
t.toString
w.send(t)}for(w=this.CW,t=w.length,s=0;s<w.length;w.length===t||(0,B.y)(w),++s)w[s].$1(d)}else A.aA("MqttConnectionHandlerBase::sendMessage - not connected",!1)},
aGJ(d){var w,v=d.a,u=v.a.a
A.aA("MqttConnectionHandlerBase::messageAvailable - message type is "+B.k(u),!1)
u.toString
w=this.ch.i(0,u)
if(w!=null)w.$1(v)
else A.aA("MqttConnectionHandlerBase::messageAvailable - WARN - no registered callback for this message type",!1)},
azh(d){var w,v,u,t,s=this,r=y.B
A.aA("MqttConnectionHandlerBase::_connectAckProcessor",!1)
try{w=x.N.a(d)
v=w.b
v===$&&B.a()
u=!0
if(v.f!==C.aO){v=w.b
v===$&&B.a()
if(v.f!==C.yq){v=w.b
v===$&&B.a()
if(v.f!==C.yp){v=w.b
v===$&&B.a()
if(v.f!==C.ys){v=w.b
v===$&&B.a()
v=v.f===C.yr}else v=u}else v=u}else v=u}else v=u
if(v){A.aA("MqttConnectionHandlerBase::_connectAckProcessor connection rejected",!1)
v=s.cy
u=w.b
u===$&&B.a()
v.b=u.f
A.aA(r,!1)
s.cy.a=C.cj}else{A.aA("MqttConnectionHandlerBase:_connectAckProcessor - state = connected",!1)
v=s.cy
v.a=C.c0
v.b=C.yo}}catch(t){if(x.L.b(B.a0(t))){A.aA(r,!1)
s.cy.a=C.cj}else throw t}A.aA("MqttConnectionHandlerBase:: cancelling connect timer",!1)
v=s.Q
v===$&&B.a()
if(v.d){u=v.c
u===$&&B.a()
u.aB()
v.d=!1
v=v.b
v===$&&B.a()
v.ex()}return!0},
azj(d){var w=d.a
w.toString
this.azh(w)}}
A.VN.prototype={
aIh(){var w,v,u,t,s,r=this
A.aA("MqttConnectionKeepAlive::pingRequired",!1)
if(r.z)return!1
else r.z=!0
w=!1
u=new A.Hl()
t=new A.iE(C.aU)
t.a=C.jb
u.a=t
v=u
t=r.y
t===$&&B.a()
if(t.cy.a===C.c0){A.aA("MqttConnectionKeepAlive::pingRequired - sending ping request",!1)
try{r.y.kI(v)
w=!0
r.as=Date.now()}catch(s){A.aA("MqttConnectionKeepAlive::pingRequired - exception occurred",!1)}}else A.aA("MqttConnectionKeepAlive::pingRequired - NOT sending ping - not connected",!1)
A.aA("MqttConnectionKeepAlive::pingRequired - restarting ping timer",!1)
t=r.a
t===$&&B.a()
r.c=B.cg(B.eb(0,t,0),r.ga6h())
if(r.b!==0){t=r.d
if(t==null){A.aA("MqttConnectionKeepAlive::pingRequired - starting disconnect timer",!1)
if(w)r.d=B.cg(B.eb(0,r.b,0),r.ga5R())
else r.a5Q()}else{t=t.b
if(t==null)if(w){A.aA("MqttConnectionKeepAlive::pingRequired - restarting disconnect timer",!1)
r.d=B.cg(B.eb(0,r.b,0),r.ga5R())}else r.a5Q()
else A.aA("MqttConnectionKeepAlive::pingRequired - disconnect timer is active, not restarting",!1)}}r.z=!1
return w},
aIg(d){var w,v=this
A.aA("MqttConnectionKeepAlive::pingRequestReceived",!1)
if(v.z)return!1
else v.z=!0
d=new A.Hm()
w=new A.iE(C.aU)
w.a=C.jc
d.a=w
w=v.y
w===$&&B.a()
w.kI(d)
v.z=!1
return!0},
aIj(d){var w,v,u,t=this
A.aA("MqttConnectionKeepAlive::pingResponseReceived",!1)
w=Date.now()-t.as
t.r=w
v=++t.Q
u=t.w
t.w=u+D.d.kL(w-u,v)
w=t.d
if(w!=null)w.aB()
return!0},
aGL(d){return!0},
aH1(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.c0){A.aA("MqttConnectionKeepAlive::noPingResponseReceived - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.zx(w,new A.yo())
A.aA("MqttConnectionKeepAlive::noPingResponseReceived - OK - disconnect event fired",!1)}else A.aA("MqttConnectionKeepAlive::noPingResponseReceived - ERROR - disconnect event not fired, no event handler",!1)}else A.aA("MqttConnectionKeepAlive::noPingResponseReceived - not disconnecting, not connected",!1)},
a5Q(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.c0){A.aA("MqttConnectionKeepAlive::noMessageSent - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.zx(w,new A.yn())
A.aA("MqttConnectionKeepAlive::noMessageSent - OK - disconnect event fired",!1)}else A.aA("MqttConnectionKeepAlive::noMessageSent - ERROR - disconnect event not fired, no event handler",!1)}else A.aA("MqttConnectionKeepAlive::noMessageSent - not disconnecting, not connected",!1)}}
A.e0.prototype={
ls(d){var w,v,u
A.bbO(d)
w=D.av.bN(d)
v=w.length
if(v>65535)throw B.f(B.ci("MqttUtf8Encoding::toUtf8 -  UTF8 string length is invalid, length is "+v))
u=new A.fL(new Uint8Array(0),0)
u.ow(v>>>8)
u.ow(v&255)
u.O(0,w)
return u}}
A.RZ.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.Si.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.UE.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.UN.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.UO.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.UP.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.W8.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibh:1}
A.VI.prototype={
azl(){var w=this,v=w.a?1:0,u=w.b?1:0,t=w.c?1:0,s=w.d,r=w.e?1:0,q=w.f?1:0,p=w.r?1:0
return(v|u<<1|t<<2|s.a<<3|r<<5|q<<6|p<<7)>>>0},
k(d){var w=this
return"Connect Flags: Reserved1="+w.a+", CleanStart="+w.b+", WillFlag="+w.c+", WillQos="+w.d.k(0)+", WillRetain="+w.e+", PasswordFlag="+w.f+", UserNameFlag="+w.r}}
A.Hi.prototype={
a1R(d,e){return this},
i7(d){var w,v,u,t,s,r,q,p=this,o=p.a
o.toString
w=new A.e0().ls(p.b.b).b
v=p.c
v===$&&B.a()
u=new A.e0()
t=u.ls(v.e).b
s=v.a
r=s.d
r===$&&B.a()
if(r.c){r=v.b
r.toString
r=u.ls(r).b
q=v.c
q.toString
t=t+r+u.ls(q).b}if(s.d.r){r=v.d
r.toString
t+=u.ls(r).b}if(s.d.f){v=v.f
v.toString
t+=u.ls(v).b}o.kH(w+1+1+2+t,d)
o=p.b
A.qC(d,o.b)
d.nH(o.c)
v=o.d
v===$&&B.a()
d.nH(v.azl())
d.mv(o.e)
o=p.c
A.qC(d,o.e)
v=o.a
s=v.d
s===$&&B.a()
if(s.c){s=o.b
s.toString
A.qC(d,s)
s=o.c
s.toString
A.qC(d,s)}if(v.d.r){s=o.d
s.toString
A.qC(d,s)}if(v.d.f){o=o.f
o.toString
A.qC(d,o)}},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(y.h+u.e+"\n")
return u.charCodeAt(0)==0?u:u}}
A.VJ.prototype={
sDg(d){var w,v=d.length
if(v>65535){w=new A.RZ()
w.a="mqtt-client::ClientIdentifierException: Client id "+d+" is too long at "+v+", Maximum ClientIdentifier length is 65535"
throw B.f(w)}this.e=d},
k(d){return y.h+this.e}}
A.mB.prototype={
H(){return"MqttConnectReturnCode."+this.b}}
A.VK.prototype={
is(d){var w=this
w.aIW(d)
w.aIX(d)
w.aIO(d)
w.aIT(d)},
k(d){var w=this,v=w.b,u=w.c,t=w.d
t===$&&B.a()
return"Connect Variable Header: ProtocolName="+v+", ProtocolVersion="+u+", ConnectFlags="+t.k(0)+", KeepAlive="+w.e}}
A.Hh.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b
if(w.y)d.nH(1)
else d.nH(0)
d.nH(w.f.a)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.t+v.y+"}, ReturnCode={"+v.f.k(0)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.apR.prototype={
is(d){d.h7()
this.aIY(d)},
k(d){return y.t+this.y+"}, ReturnCode={"+this.f.k(0)+"}"}}
A.Hj.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.iE.prototype={
kH(d,e){var w,v,u,t,s,r=this
r.e=d
w=new A.fL(new Uint8Array(0),0)
v=r.a.a
u=r.b?1:0
t=r.c
s=r.d?1:0
w.ow((v<<4>>>0)+(u<<3>>>0)+(t.a<<1>>>0)+s)
w.O(0,r.a8y())
e.jI(w)},
is(d){var w,v,u,t,s,r=this,q="The header being processed contained an invalid size byte pattern. Message size must take a most 4 bytes, and the last byte must have bit 8 set to 0."
if(d.a.b<2){d.b=0
throw B.f(A.alk("The supplied header is invalid. Header must be at least 2 bytes long."))}u=d.h7()
r.d=(u&1)===1
r.c=A.aq2(u>>>1&3)
r.b=(u>>>3&1)===1
r.a=C.OY[u>>>4&15]
try{r.e=A.bbP(A.bbQ(d))}catch(t){s=B.a0(t)
if(x.L.b(s)){w=B.ak(t)
B.fW(A.alk(q),w)}else if(x.C.b(s)){v=B.ak(t)
B.fW(A.alk(q),v)}else throw t}},
a8y(){var w,v,u=new A.fL(new Uint8Array(0),0),t=this.e
do{w=D.d.aX(t,128)
t=D.d.bT(t,128)
v=t>0
u.ow(v?(w|128)>>>0:w)}while(v)
return u},
k(d){var w=this
return"Header: MessageType = "+B.k(w.a)+", Duplicate = "+w.b+", Retain = "+w.d+", Qos = "+w.c.k(0)+", Size = "+w.e}}
A.dD.prototype={
i7(d){this.a.kH(0,d)},
is(d){return},
k(d){var w="MQTTMessage of type "+(J.bg(this.a.a)+"\n")+(J.bg(this.a)+"\n")
return w.charCodeAt(0)==0?w:w}}
A.fm.prototype={
H(){return"MqttMessageType."+this.b}}
A.apS.prototype={}
A.aq3.prototype={
hM(){this.b="MQIsdp"
this.c=3
this.d=new A.VI(C.aU)},
aIW(d){var w=A.qB(d)
this.b=w
this.a=this.a+(w.length+2)},
aIX(d){this.c=d.h7();++this.a},
aIT(d){this.e=d.a6B()
this.a+=2},
aIY(d){this.f=C.On[d.h7()];++this.a},
aIZ(d){var w=A.qB(d)
this.r=w
this.a=w.length+2},
nz(d){this.w=d.a6B()
this.a+=2},
aIO(d){var w=new A.VI(C.aU),v=d.h7()
w.a=(v&1)===1
w.b=(v&2)===2
w.c=(v&4)===4
w.d=A.aq2(D.d.aI(v,3)&3)
w.e=(v&32)===32
w.f=(v&64)===64
w.r=(v&128)===128
this.d=w;++this.a},
gE(d){return this.a}}
A.Hl.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.Hm.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.v5.prototype={
i7(d){var w,v,u=this,t=u.b,s=new A.e0().ls(t.r).b
t=t.y.c
if(t===C.bL||t===C.eD)s+=2
t=u.c
t===$&&B.a()
t=t.c
t===$&&B.a()
w=t.b
u.a.kH(s+w,d)
t=u.b
A.qC(d,t.r)
v=t.y.c
if(v===C.bL||v===C.eD){t=t.w
t.toString
d.mv(t)}t=u.c.c
t===$&&B.a()
d.jI(t)},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=u.c
u===$&&B.a()
u=w+(v+"\n")+("Payload: {"+u.b+" bytes={"+A.aZs(u)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.VQ.prototype={
k(d){var w=this.c
w===$&&B.a()
return"Payload: {"+w.b+" bytes={"+A.aZs(w)}}
A.VT.prototype={
is(d){var w
this.aIZ(d)
w=this.y.c
if(w===C.bL||w===C.eD)this.nz(d)},
k(d){return"Publish Variable Header: TopicName={"+this.r+"}, MessageIdentifier={"+B.k(this.w)+"}, VH Length={"+this.a+"}"}}
A.zy.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mv(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.p+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VO.prototype={
k(d){return y.p+B.k(this.w)+"}"}}
A.zz.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mv(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.w+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VP.prototype={
k(d){return y.w+B.k(this.w)+"}"}}
A.zA.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mv(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.g+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VR.prototype={
k(d){return y.g+B.k(this.w)+"}"}}
A.zB.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mv(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.i+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VS.prototype={
k(d){return y.i+B.k(this.w)+"}"}}
A.Ho.prototype={
i7(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kH(2+w.H1(),d)
w=v.b.w
w.toString
d.mv(w)
v.c.i7(d)},
aK7(d){var w
this.d=d
w=this.c
w===$&&B.a()
w.c.h(0,d,C.aU)
return this},
axN(d){var w=this,v=w.c
v===$&&B.a()
if(v.c.G(w.d))w.c.c.h(0,w.d,d)
return w},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.VU.prototype={
i7(d){this.c.am(0,new A.apZ(d))},
is(d){var w,v,u,t=this.b.e-this.a.a
for(w=this.c,v=0;v<t;){u=A.qB(d)
v+=u.length+3
w.h(0,u,A.aq2(d.h7()))}},
H1(){var w={}
w.a=0
this.c.am(0,new A.apX(w,new A.e0()))
return w.a},
k(d){var w=new B.cQ(""),v=this.c
w.a="Payload: Subscription [{"+v.a+"}]\n"
v.am(0,new A.apY(w))
v=w.a
return v.charCodeAt(0)==0?v:v}}
A.VV.prototype={
k(d){return"Subscribe Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Hn.prototype={
i7(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kH(2+w.c.length,d)
w=v.b.w
w.toString
d.mv(w)
v.c.i7(d)},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.apV.prototype={
i7(d){var w,v,u
for(w=this.c,v=w.length,u=0;u<w.length;w.length===v||(0,B.y)(w),++u)d.nH(w[u].a)},
is(d){var w,v,u=this.b.e-this.a.a
for(w=this.c,v=0;v<u;){++v
w.push(A.aq2(d.h7()))}},
k(d){var w,v=this.c,u=v.length,t="Payload: Qos grants [{"+u+"}]\n"
for(w=0;w<v.length;v.length===u||(0,B.y)(v),++w)t+="{{ Grant={"+v[w].k(0)+"} }}\n"
return t.charCodeAt(0)==0?t:t}}
A.apW.prototype={
k(d){return"SubscribeAck Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.VW.prototype={
i7(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kH(2+w.H1(),d)
w=v.b.w
w.toString
d.mv(w)
D.b.am(v.c.c,d.gaKO())},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.aq0.prototype={
is(d){var w,v,u,t=this.b.e-this.a.a
for(w=this.c,v=0;v<t;){u=A.qB(d)
v+=u.length+2
w.push(u)}},
H1(){var w,v,u,t,s=new A.e0()
for(w=this.c,v=w.length,u=0,t=0;t<w.length;w.length===v||(0,B.y)(w),++t)u+=s.ls(w[t]).b
return u},
k(d){var w,v=this.c,u=v.length,t="Payload: Unsubscription [{"+u+"}]\n"
for(w=0;w<u;++w)t+="{{ Topic={"+v[w]+"}}\n"
return t.charCodeAt(0)==0?t:t}}
A.aq1.prototype={
k(d){return"Unsubscribe VariableHeader Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Hp.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mv(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.k+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.aq_.prototype={
k(d){return y.k+B.k(this.w)+"}"}}
A.Hg.prototype={
ga2q(){var w=this.y
return w!=null?w.cy:this.ch},
sMY(d){var w
this.CW=d
w=d.b
if(w!=null)w.c=3
w=d.b
if(w!=null)w.b="MQIsdp"},
xx(d,e){return this.azf(d,e)},
azf(d,e){var w=0,v=B.L(x.F),u,t=this,s,r,q,p,o,n,m
var $async$xx=B.G(function(f,g){if(f===1)return B.I(g,v)
for(;;)switch(w){case 0:if(!t.d){s=new A.UE()
s.a="mqtt-client::ClientIncorrectInstantiationException: Incorrect instantiation, do notinstantiate MqttClient directly, use MqttServerClient or MqttBrowserClient"
throw B.f(s)}$.aZq=$.aZq+1
s=t.CW
if(s!=null)s.a1R(d,e)
r=t.y
if(r==null)throw B.f(B.ax("connectionHandler is null"))
s=t.z
if(s!=null)r.at=s
r.b=t.gaFj()
r.e=r.d=r.c=r.a=null
A.aA("MqttClient::connect - Connection timeout period is 5000 milliseconds",!1)
s=t.k1
q=$.b5n()
p=x.S
o=x.c
s=new A.Xi(q,B.o(p,o),B.o(p,o),B.o(x.I,o),B.o(x.E,x.K),r,new B.er(null,null,x.U),s)
o=r.ch
o.h(0,C.je,s.gaDU())
o.h(0,C.jd,s.gaDS())
o.h(0,C.jh,s.gaDW())
o.h(0,C.jg,s.gaE_())
o.h(0,C.jf,s.gaDY())
t.ay=s
s.r=!1
s=t.k1
n=x.Z
q=new A.Zo(q,B.o(p,n),B.o(p,n),B.o(p,n),r,s,new B.hy(null,null,x.M))
o.h(0,C.mZ,q.gazb())
o.h(0,C.mV,q.gazd())
s.ra(x.b).e7(q.gaIw())
s.ra(x.k).e7(q.gats())
t.Q=q
q.x=q.w=q.r=null
q.y=!0
s=t.at
if(s!==0){A.aA("MqttClient::connect - keep alive is enabled with a value of "+s+" seconds",!1)
s=t.k1
q=t.at
p=new A.VN()
p.y=r
p.x=s
p.a=q*1000
o.h(0,C.jb,p.gaIf())
o.h(0,C.jc,p.gaIi())
r.CW.push(p.gaGK())
p.c=B.cg(B.eb(0,p.a,0),p.ga6h())
A.aA("MqttConnectionKeepAlive:: Initialised with a keep alive value of "+q+" seconds",!1)
A.aA("MqttConnectionKeepAlive:: Disconnect on no ping response is disabled",!1)
t.as=p}else A.aA("MqttClient::connect - keep alive is disabled",!1)
m=t.CW
if(m==null){s=A.aZp()
q=s.c
q===$&&B.a()
q.sDg(t.c)
q=s.b.d
q===$&&B.a()
q.d=C.aU
m=s.a1R(d,e)
s=m.b.d
s===$&&B.a()
s.b=!0
t.sMY(m)}s=m.c
s===$&&B.a()
if(s.e.length===0)s.sDg(t.c)
s=m.b
if(s!=null)s.e=t.at
t.sMY(m)
u=r.xy(t.a,t.b,m)
w=1
break
case 1:return B.J(u,v)}})
return B.K($async$xx,v)},
aIv(d,e,f,g){var w,v,u,t,s,r,q,p,o,n,m=null,l=this.y,k=l==null
if((k?m:l.cy.a)!==C.c0)throw B.f(A.aX0(k?m:l.cy.a))
try{w=A.aSW(d)
l=this.ay
l.toString
k=w.a
A.aA("PublishingManager::publish - entered with topic "+k,!1)
t=l.a.GW()
s=new A.v5()
r=new A.iE(C.aU)
r.a=C.jd
s.a=r
q=new A.VT(r,C.aO,new A.e0())
q.hM()
s.b=q
p=new A.VQ(m,m)
o=new A.fL(new Uint8Array(0),0)
p.c=o
s.c=p
q.r=k
q.w=t
r.c=e
o.O(0,f)
r.d=!0
if(e===C.bL||e===C.eD)l.b.h(0,t,s)
l.f.kI(s)
return t}catch(n){l=B.a0(n)
if(x.L.b(l)){v=l
u=B.ak(n)
l=new A.UP()
l.a="mqtt-client::InvalidTopicException: Topic "+d+" is "+J.bg(v)
B.fW(l,u)}else throw n}},
aBr(d){var w
A.aA("MqttClient::_disconnectOnNoPingResponse - disconnecting, no ping request response for 0 seconds",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.Pp()}this.OJ()},
aBp(d){var w
A.aA("MqttClient::disconnectOnNoMessageSent - disconnecting, no message sent due to exception like socket exception",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.Pp()}this.OJ()},
OJ(){var w=this.y
if(w==null){A.aA("MqttClient::internalDisconnect - not invoking disconnect, no connection handler",!1)
return}if(w.cx)this.J_(!0)},
J_(d){var w,v,u,t,s=this
if(!d){w=s.y
if(w!=null){A.aA("MqttConnectionHandlerBase::disconnect - entered",!1)
if(w.cy.a===C.c0){v=new A.Hj()
u=new A.iE(C.aU)
u.a=C.mW
v.a=u
w.kI(v)}A.aA(y.B,!1)
w.cy.a=C.cj}w=s.y
if(w!=null){v=w.ay
v===$&&B.a()
v.vC()
w.ay.Dh()}t=C.SS}else t=C.SR
w=s.ay
if(w!=null)w.x.b1()
s.ay=null
w=s.Q
if(w!=null)w.Q.b1()
s.Q=null
w=s.as
if(w!=null){A.aA("MqttConnectionKeepAlive::stop - stopping keep alive",!1)
w.c.aB()
v=w.d
if(v!=null)v.aB()
w.Q=w.w=w.r=0}s.as=null
w=s.ch
v=s.ga2q().b
w.b=v
s.y=null
v=s.k1
if(v!=null)v.a.b1()
s.k1=null
w.a=C.cj
w.c=t
w=s.cx
if(w!=null)w.$0()}}
A.k7.prototype={
k(d){return"Connection status is "+this.a.H().split(".")[1]+" with return code of "+J.bg(this.b).split(".")[1]+" and a disconnection origin of "+this.c.H().split(".")[1]}}
A.zr.prototype={}
A.y6.prototype={}
A.qy.prototype={}
A.xx.prototype={}
A.Au.prototype={}
A.yo.prototype={}
A.yn.prototype={}
A.ap_.prototype={
GW(){var w=++this.a
return w===32768?this.a=1:w}}
A.l4.prototype={
H(){return"MqttQos."+this.b}}
A.ok.prototype={}
A.Xh.prototype={}
A.Xi.prototype={
aDV(d){var w,v=x.z.a(d).b
v===$&&B.a()
w=v.w
A.aA("PublishingManager::handlePublishAcknowledgement for message id "+B.k(w),!1)
v=this.b
if(v.G(w)){w.toString
this.Y8(v.i(0,w))
v.F(0,w)}return!0},
aDT(d){var w,v,u,t,s,r,q,p,o,n,m=this
x.c.a(d)
w=d
v=!0
try{u=A.aSW(w.b.r)
A.aA("PublishingManager::handlePublish - publish received from broker with topic "+B.k(u),!1)
if(w.a.c===C.aU){q=m.y
if(q!=null)A.zx(q,new A.qy(d,u))}else if(w.a.c===C.bL){q=m.y
if(q!=null)A.zx(q,new A.qy(d,u))
t=w.b.w
p=new A.zy()
q=new A.iE(C.aU)
q.a=C.je
p.a=q
q=new A.VO(C.aO,new A.e0())
q.hM()
p.b=q
q.w=t
s=p
m.f.kI(s)}else if(w.a.c===C.eD){q=m.d
if(!q.G(w.b.w))q.h(0,w.b.w,w)
o=new A.zA()
q=new A.iE(C.aU)
q.a=C.jf
o.a=q
q=new A.VR(C.aO,new A.e0())
q.hM()
o.b=q
q.w=w.b.w
r=o
m.f.kI(r)}}catch(n){if(x.L.b(B.a0(n)))v=!1
else throw n}return v},
aE0(d){var w,v,u,t,s,r,q,p=x.G.a(d).b
p===$&&B.a()
w=p.w
A.aA("PublishingManager::handlePublishRelease - for message identifier "+B.k(w),!1)
v=!0
try{u=this.d.F(0,w)
if(u!=null){t=A.aSW(u.b.r)
p=this.y
if(p!=null)A.zx(p,new A.qy(u,t))
r=new A.zz()
p=new A.iE(C.aU)
p.a=C.jh
r.a=p
p=new A.VP(C.aO,new A.e0())
p.hM()
r.b=p
p.w=u.b.w
s=r
this.f.kI(s)}}catch(q){if(x.L.b(B.a0(q)))v=!1
else throw q}return v},
aDX(d){var w,v=x.a.a(d).b
v===$&&B.a()
w=v.w
A.aA("PublishingManager::handlePublishComplete - for message identifier "+B.k(w),!1)
this.Y8(this.b.F(0,w))
return!0},
aDZ(d){var w,v,u
x.R.a(d)
w=d.b
w===$&&B.a()
v=w.w
A.aA("PublishingManager::handlePublishReceived - for message identifier "+B.k(v),!1)
if(this.b.G(v)){u=new A.zB()
w=new A.iE(C.aU)
w.a=C.jg
u.a=w
w.c=C.bL
w=new A.VS(C.aO,new A.e0())
w.hM()
u.b=w
w.w=d.b.w
this.f.kI(u)}return!0},
Y8(d){var w=this.x
if(w.d!=null&&d!=null){A.aA("PublishingManager::_notifyPublish - adding message to published stream for topic "+d.b.r,!1)
A.aZt(w,d)}}}
A.B_.prototype={
glk(){return this.w},
grv(){var w=this.x
return w},
gya(){var w=this.e,v=B.Z(w).j("b0<1>")
w=B.V(new B.b0(w,new A.ayp(),v),v.j("A.E"))
return w},
gAd(){var w=this.e,v=B.Z(w).j("b0<1>")
w=B.V(new B.b0(w,new A.ayq(),v),v.j("A.E"))
return w},
gA(d){var w=D.c.gA(this.grv().a),v=B.fH(this.glk()),u=this.c?519018:218159
return w+v+u},
aKs(d){var w,v,u=this
if(d.length!==u.gya().length+u.gAd().length)return!1
for(w=0;w<u.gya().length+u.gAd().length;++w)u.e[w].slk(d[w])
v=D.b.ga2(u.e).glk()
if(!u.c)u.w=v
return!0},
l(d,e){var w,v=this
if(e==null)return!1
if(v!==e)w=e instanceof A.B_&&B.q(v)===B.q(e)&&v.grv().a===e.grv().a&&v.glk()===e.glk()&&v.c===e.c&&v.b==e.b
else w=!0
return w},
k(d){var w=this,v="Subscription:: Batch: "+w.c+", MID: "+B.k(w.b)+", Topic: "+w.grv().a+", QoS: "+w.glk().k(0)+", Total Batch: "+(w.gya().length+w.gAd().length)+"\n"
return v.charCodeAt(0)==0?v:v}}
A.Zn.prototype={}
A.Zo.prototype={
aKn(d){var w,v,u
for(w=this.b,w=new B.bz(w,w.r,w.e,B.l(w).j("bz<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}for(w=this.c,w=new B.bz(w,w.r,w.e,B.l(w).j("bz<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}return null},
a2M(d,e){var w,v,u,t,s,r,q,p
try{w=A.aTg(d)
v=this.a.GW()
u=A.aTf()
u.x=w
r=u
if(!r.c)r.w=e
u.b=v
Date.now()
this.c.h(0,v,u)
r=A.aZu()
q=u.b
r.b.w=q
t=r.aK7(u.grv().a).axN(u.glk())
this.e.kI(t)
return u}catch(p){r=B.a0(p)
if(x.L.b(r)){s=r
A.aA("SubscriptionsManager::createNewSubscription exception raised, text is "+B.k(s),!1)
return null}else throw p}},
aAH(d){var w,v,u,t,s,r,q,p,o,n,m,l
try{w=A.aTg(D.b.ga2(d).grv())
v=this.a.GW()
u=A.aTf()
u.c=!0
u.x=w
u.e=d
u.r=d
u.b=v
Date.now()
this.c.h(0,v,u)
q=A.aZu()
q.b.w=v
t=q
for(p=0;!1;++p){s=d[p]
o=t
n=s.grv()
o.d=n
o=o.c
o===$&&B.a()
o.c.h(0,n,C.aU)
n=t
o=s.glk()
m=n.c
m===$&&B.a()
if(m.c.G(n.d))n.c.c.h(0,n.d,o)}this.e.kI(t)
return u}catch(l){o=B.a0(l)
if(x.L.b(o)){r=o
A.aA("SubscriptionsManager::createNewBatchSubscription exception raised, text is "+B.k(r),!1)
return null}else throw l}},
aIx(d){A.aZt(this.Q,B.b([new A.ok(d.a,x.X)],x.f))},
azc(d){var w,v,u,t
x.A.a(d)
w=d.b.w
w.toString
A.aTf()
v=this.c
if(v.G(w))u=v.i(0,w)
else{A.aA("SubscriptionsManager::confirmSubscription Sub Ack received for non pending subscription",!1)
return!1}if(!u.c){t=d.c
t===$&&B.a()
t=t.c
if(t.length===0||D.b.ga2(t)===C.n_){v.F(0,w)
A.aA("SubscriptionsManager::confirmSubscription failed for single subscription "+D.b.ga2(d.c.c).k(0),!1)
return!1}}else{t=d.c
t===$&&B.a()
if(!u.aKs(t.c)){v.F(0,w)
A.aA("SubscriptionsManager::confirmSubscription failed to update qos grants for batch subscription, lengths differ","Requested: 0, Received: "+d.c.c.length)
return!1}if(d.c.c.length===0||u.gya().length===u.gya().length+u.gAd().length){v.F(0,w)
A.aA("SubscriptionsManager::confirmSubscription all qos grants failed",!1)
return!1}}v.F(0,w)
this.b.h(0,w,u)
return!0},
aze(d){var w,v=x.D.a(d).b
v===$&&B.a()
w=v.w
v=this.d
if(v.G(w)){v.i(0,w)
this.b.F(0,null)}A.aA("SubscriptionsManager::confirmUnsubscribe subscription not found in pending unsubscriptions",!1)
return!0},
att(d){var w,v,u,t,s,r,q,p=this
A.aA("Subscriptionsmanager::_resubscribe - resubscribing from auto reconnect "+d.a,!1)
w=p.b
v=B.l(w).j("bu<2>")
u=B.V(new B.bu(w,v),v.j("A.E"))
v=p.c
t=B.l(v).j("bu<2>")
s=B.V(new B.bu(v,t),t.j("A.E"))
w.M(0)
v.M(0)
w=B.V(u,x.Z)
D.b.O(w,s)
v=w.length
r=0
for(;r<w.length;w.length===v||(0,B.y)(w),++r){q=w[r]
if(q.c)p.aAH(q.r)
else{t=q.x
p.a2M(t.a,q.glk())}}}}
A.oY.prototype={
gA(d){return D.c.gA(this.a)},
Th(d,e){var w,v
this.b=B.b(this.a.split("/"[0]),x.s)
for(w=e.length,v=0;v<e.length;e.length===w||(0,B.y)(e),++v)e[v].$1(this)},
l(d,e){if(e==null)return!1
if(this===e)return!0
return e instanceof A.oY&&this.a===e.a},
k(d){return this.a}}
A.zv.prototype={
gE(d){return this.a.b},
aFL(){if(this.a.b-this.b>0)return!0
return!1},
h7(){var w=this,v=w.a.i(0,w.b),u=w.b
if(u<=w.a.b-1)w.b=u+1
else return-1
return v},
a6B(){return(this.h7()<<8>>>0)+this.h7()},
ny(d){var w,v,u,t,s=this,r=null,q=s.a,p=q.b
if(p<d||s.b+d>p)throw B.f(B.ci("mqtt_client::ByteBuffer::read: The buffer does not have enough bytes for the read operation length "+s.gE(0)+", count "+d+", position "+s.b+", buffer "+q.k(q)))
if($.aZo){w=new A.fL(new Uint8Array(0),0)
p=s.b
v=p+d
B.dE(p,v,q.gE(0),r,r)
w.O(0,B.hr(q,p,v,B.l(q).j("aU.E")))
s.b+=d
u=new A.fL(new Uint8Array(0),0)
u.O(0,w)
return u}else{p=s.b+=d
v=new A.fL(new Uint8Array(0),0)
t=p-d
B.dE(t,p,q.gE(0),r,r)
v.O(0,B.hr(q,t,p,B.l(q).j("aU.E")))
return v}},
aIV(d){var w,v,u,t=this,s=t.a,r=s.b
if(r<d||t.b+d>r)throw B.f(B.ci("mqtt_client::ByteBuffer::readPayload: The buffer does not have enough bytes for the read operation length "+t.gE(0)+", count "+d+", position "+t.b+", buffer "+s.k(s)))
if(d<=32767)return t.ny(d)
r=t.b
if(r!==0){s.G3(s,0,r)
s=t.b=0}else s=r
w=new A.fL(new Uint8Array(0),0)
r=t.a
v=r.b
if(v===d){t.b=v
s=new A.fL(new Uint8Array(0),0)
s.O(0,r)
return s}else{s+=d
B.dE(s,v,r.gE(0),null,null)
w.O(0,B.hr(r,s,v,B.l(r).j("aU.E")).eo(0))
r=t.a
r.G3(r,t.b+d,r.b)
u=new A.fL(new Uint8Array(0),0)
u.O(0,t.a)
t.a.sE(0,0)
t.a.O(0,w)
t.b=0
return u}},
nH(d){var w=this.a,v=w.b,u=this.b
if(v===u)w.ow(d)
else w.h(0,u,d);++this.b},
mv(d){this.nH(D.d.aI(d,8))
this.nH(d&255)},
jI(d){this.a.O(0,d)
this.b=this.a.b},
aKP(d){A.qC(this,d)},
k(d){var w,v=this.a
v=v.ga6(v)
if(!v){v=this.a
w=B.mn(v.eo(v),"[","]")}else w="null or empty"
return w}}
A.apQ.prototype={
gE(d){return this.a.b},
axp(d){var w,v,u,t,s,r
for(w=new B.fT(d),v=x.V,w=new B.bR(w,w.gE(0),v.j("bR<aU.E>")),u=x.t,v=v.j("aU.E");w.v();){t=w.d
if(t==null)t=v.a(t)
if(t<=255&&t>=0)this.a.ow(t)
else{s=new Uint16Array(B.b3(B.b([t],u)))
t=this.a
r=J.b7E(D.n1.gbe(s))
t.a06(r,0,null)}}return this}}
A.VH.prototype={
avD(){this.d=!1
var w=this.b
w===$&&B.a()
w.ex()}}
A.Ry.prototype={}
A.We.prototype={}
A.Eh.prototype={}
A.Bg.prototype={
gE(d){return this.b},
i(d,e){if(e>=this.b)throw B.f(B.UF(e,this,null,null,null))
return this.a[e]},
h(d,e,f){var w
if(e>=this.b)throw B.f(B.UF(e,this,null,null,null))
w=this.a
w.$flags&2&&B.a4(w)
w[e]=f},
sE(d,e){var w,v,u,t,s=this,r=s.b
if(e<r)for(w=s.a,v=w.$flags|0,u=e;u<r;++u){v&2&&B.a4(w)
w[u]=0}else{r=s.a.length
if(e>r){if(r===0)t=new Uint8Array(e)
else t=s.LA(e)
D.l.bR(t,0,s.b,s.a)
s.a=t}}s.b=e},
ow(d){var w,v=this,u=v.b
if(u===v.a.length)v.a07(u)
u=v.a
w=v.b++
u.$flags&2&&B.a4(u)
u[w]=d},
t(d,e){var w,v=this,u=v.b
if(u===v.a.length)v.a07(u)
u=v.a
w=v.b++
u.$flags&2&&B.a4(u)
u[w]=e},
tG(d,e,f,g){B.fb(f,"start")
this.a06(e,f,g)},
O(d,e){return this.tG(0,e,0,null)},
a06(d,e,f){var w,v,u
if(x.j.b(d))f=J.aT(d)
if(f!=null){this.avP(this.b,d,e,f)
return}for(w=J.bx(d),v=0;w.v();){u=w.gN()
if(v>=e)this.ow(u);++v}if(v<e)throw B.f(B.ax("Too few elements"))},
avP(d,e,f,g){var w,v,u,t,s=this
if(x.j.b(e)){w=J.aa(e)
if(f>w.gE(e)||g>w.gE(e))throw B.f(B.ax("Too few elements"))}v=g-f
u=s.b+v
s.avO(u)
w=s.a
t=d+v
D.l.bD(w,t,s.b+v,w,d)
D.l.bD(s.a,d,t,e,f)
s.b=u},
avO(d){var w,v=this
if(d<=v.a.length)return
w=v.LA(d)
D.l.bR(w,0,v.b,v.a)
v.a=w},
LA(d){var w=this.a.length*2
if(d!=null&&w<d)w=d
else if(w<8)w=8
return new Uint8Array(w)},
a07(d){var w=this.LA(null)
D.l.bR(w,0,d,this.a)
this.a=w},
bD(d,e,f,g,h){var w=this.b
if(f>w)throw B.f(B.co(f,0,w,null,null))
w=this.a
if(g instanceof A.fL)D.l.bD(w,e,f,g.a,h)
else D.l.bD(w,e,f,g,h)},
bR(d,e,f,g){return this.bD(0,e,f,g,0)}}
A.a3n.prototype={}
A.fL.prototype={}
var z=a.updateTypes(["D(dD?)","~(oY)","~()","~(h?,l4?)","D(aWv)","~(H<ok<dD>>)","~(xx)","~(zr)","~(y6)","D()","~(yo)","~(yn)","~(qy)","~(Au)","~(h)"])
A.aho.prototype={
$1(d){return this.a.b(d)},
$S:561}
A.apT.prototype={
$0(){var w=this.a
w.f=!1
if(!w.d)w.aG()},
$S:0}
A.apU.prototype={
$1(d){var w,v=x.c.a(J.c3(d,0).b),u=v.c
u===$&&B.a()
u=u.c
u===$&&B.a()
w=A.bbT(u)
this.a.Br(w,this.b)},
$S:z+5}
A.apJ.prototype={
$1(d){return d},
$S:51}
A.apK.prototype={
$1(d){var w,v
A.aA("MqttBrowserWsConnection::connect - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
this.b.a_x()
return this.c.ex()},
$S:2}
A.apL.prototype={
$1(d){var w,v
A.aA("MqttBrowserWsConnection::connect - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apM.prototype={
$1(d){var w,v
A.aA("MqttBrowserWsConnection::connect - websocket has erred",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apF.prototype={
$1(d){return d},
$S:51}
A.apG.prototype={
$1(d){var w,v
A.aA("MqttBrowserWsConnection::connectAuto - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
this.b.a_x()
return this.c.ex()},
$S:2}
A.apH.prototype={
$1(d){var w,v
A.aA("MqttBrowserWsConnection::connectAuto - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apI.prototype={
$1(d){var w,v
A.aA("MqttBrowserWsConnection::connectAuto - websocket has errored",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apN.prototype={
$1(d){A.aA("MqttBrowserConnection::_startListening - websocket is closed",!1)
this.a.Pp()},
$S:2}
A.apO.prototype={
$1(d){this.a.pj(d.data)},
$S:2}
A.apP.prototype={
$1(d){var w
A.aA("MqttBrowserConnection::_startListening - websocket has errored",!1)
w=this.a
w.vC()
w.Dh()
w.a=null
if(w.e!=null){A.aA("MqttConnectionBase::_onError - calling disconnected callback",!1)
w.e.$0()}},
$S:2}
A.apZ.prototype={
$2(d,e){var w=this.a
d.toString
A.qC(w,d)
w.nH(e.a)},
$S:z+3}
A.apX.prototype={
$2(d,e){var w,v=this.a,u=v.a
d.toString
w=u+this.b.ls(d).b
v.a=w
v.a=w+1},
$S:z+3}
A.apY.prototype={
$2(d,e){var w=this.a,v="{{ Topic={"+B.k(d)+"}, Qos={"+B.k(e)+"} }}\n"
w.a+=v},
$S:z+3}
A.ayp.prototype={
$1(d){d.glk()
return!1},
$S:z+4}
A.ayq.prototype={
$1(d){d.glk()
return!0},
$S:z+4}
A.ayo.prototype={
$1(d){return(D.c.p(d,"#")||D.c.p(d,"+"))&&d.length>1},
$S:28};(function aliases(){var w=A.dD.prototype
w.SG=w.is
w.iD=w.k
w=A.Hg.prototype
w.abb=w.xx})();(function installTearOffs(){var w=a._instance_0u,v=a._static_1,u=a._instance_1u
w(A.jl.prototype,"gcX","m",2)
v(A,"blm","bd2",1)
v(A,"blo","bel",1)
v(A,"bln","bek",1)
v(A,"b3T","beZ",1)
v(A,"b3U","bf_",1)
var t
u(t=A.VM.prototype,"gay_","D3",6)
u(t,"gaGI","aGJ",7)
u(t,"gazi","azj",8)
w(t=A.VN.prototype,"ga6h","aIh",9)
u(t,"gaIf","aIg",0)
u(t,"gaIi","aIj",0)
u(t,"gaGK","aGL",0)
w(t,"ga5R","aH1",2)
u(t=A.Hg.prototype,"gaBq","aBr",10)
u(t,"gaBo","aBp",11)
w(t,"gaFj","OJ",2)
u(t=A.Xi.prototype,"gaDU","aDV",0)
u(t,"gaDS","aDT",0)
u(t,"gaE_","aE0",0)
u(t,"gaDW","aDX",0)
u(t,"gaDY","aDZ",0)
u(t=A.Zo.prototype,"gaIw","aIx",12)
u(t,"gazb","azc",0)
u(t,"gazd","aze",0)
u(t,"gats","att",13)
u(A.zv.prototype,"gaKO","aKP",14)
w(A.VH.prototype,"gavC","avD",2)})();(function inheritance(){var w=a.mixin,v=a.inheritMany,u=a.inherit
v(B.t,[A.ahn,A.a4a,A.VL,A.VM,A.Hg,A.VN,A.e0,A.RZ,A.Si,A.UE,A.UN,A.UO,A.UP,A.W8,A.VI,A.dD,A.apS,A.aq3,A.iE,A.k7,A.zr,A.y6,A.qy,A.xx,A.Au,A.yo,A.yn,A.ap_,A.Eh,A.oY,A.Xi,A.We,A.Zo,A.zv,A.apQ,A.VH,A.Ry])
v(B.dZ,[A.aho,A.apU,A.apJ,A.apK,A.apL,A.apM,A.apF,A.apG,A.apH,A.apI,A.apN,A.apO,A.apP,A.ayp,A.ayq,A.ayo])
u(A.jl,A.a4a)
u(A.apT,B.fz)
u(A.VG,A.VL)
u(A.apD,A.VM)
u(A.apE,A.VG)
u(A.ayt,A.apD)
u(A.apC,A.Hg)
v(B.iT,[A.Hk,A.zw,A.mB,A.fm,A.l4])
v(A.dD,[A.Hi,A.Hh,A.Hj,A.Hl,A.Hm,A.v5,A.zy,A.zz,A.zA,A.zB,A.Ho,A.Hn,A.VW,A.Hp])
v(A.apS,[A.VJ,A.VQ,A.VU,A.apV,A.aq0])
v(A.aq3,[A.VK,A.apR,A.VT,A.VO,A.VP,A.VR,A.VS,A.VV,A.apW,A.aq1,A.aq_])
v(B.fS,[A.apZ,A.apX,A.apY])
u(A.ok,A.Eh)
v(A.oY,[A.Xh,A.Zn])
u(A.B_,A.We)
u(A.Bg,B.aU)
u(A.a3n,A.Bg)
u(A.fL,A.a3n)
w(A.a4a,B.aN)})()
B.fP(b.typeUniverse,JSON.parse('{"jl":{"aN":[],"a9":[]},"v5":{"dD":[]},"B_":{"We":["Eh"]},"RZ":{"bh":[]},"Si":{"bh":[]},"UE":{"bh":[]},"UN":{"bh":[]},"UO":{"bh":[]},"UP":{"bh":[]},"W8":{"bh":[]},"Hi":{"dD":[]},"Hh":{"dD":[]},"Hj":{"dD":[]},"Hl":{"dD":[]},"Hm":{"dD":[]},"zy":{"dD":[]},"zz":{"dD":[]},"zA":{"dD":[]},"zB":{"dD":[]},"Ho":{"dD":[]},"Hn":{"dD":[]},"VW":{"dD":[]},"Hp":{"dD":[]},"Xh":{"oY":[]},"Zn":{"oY":[]},"Bg":{"aU":["1"],"H":["1"],"aL":["1"],"A":["1"]},"a3n":{"Bg":["m"],"aU":["m"],"H":["m"],"aL":["m"],"A":["m"]},"fL":{"Bg":["m"],"aU":["m"],"H":["m"],"aL":["m"],"A":["m"],"aU.E":"m","A.E":"m"}}'))
B.lD(b.typeUniverse,JSON.parse('{"VG":1,"VL":1}'))
var y={t:"Connect Variable Header: SessionPresent={",a:"Guarded fire - event bus is closed - event not fired",h:"MqttConnectPayload - client identifier is : ",B:"MqttConnectionHandlerBase::_performConnectionDisconnect entered",p:"PublishAck Variable Header: MessageIdentifier={",w:"PublishComplete Variable Header: MessageIdentifier={",g:"PublishReceived Variable Header: MessageIdentifier={",i:"PublishRelease Variable Header: MessageIdentifier={",k:"UnsubscribeAck Variable Header: MessageIdentifier={"}
var x=(function rtii(){var w=B.T
return{h:w("xx"),Q:w("Ry<Eh>"),V:w("fT"),_:w("y6"),o:w("yn"),u:w("yo"),C:w("cu"),L:w("bh"),y:w("n<aWv>"),r:w("n<oa>"),v:w("n<l4>"),f:w("n<ok<dD>>"),p:w("n<boj>"),d:w("n<hP<@>>"),s:w("n<h>"),t:w("n<m>"),B:w("n<D(dD?)>"),x:w("n<~(oY)>"),m:w("bd"),j:w("H<@>"),W:w("zr"),b:w("qy"),e:w("k7"),N:w("Hh"),q:w("fm"),z:w("zy"),a:w("zz"),c:w("v5"),R:w("zA"),G:w("zB"),X:w("ok<dD>"),A:w("Hn"),D:w("Hp"),K:w("t"),k:w("Au"),P:w("c2<H<ok<dD>>>"),Z:w("B_"),E:w("hu"),U:w("er<v5>"),J:w("er<@>"),l:w("b2<k7?>"),Y:w("b2<~>"),w:w("ab<k7?>"),g:w("ab<~>"),M:w("hy<H<ok<dD>>>"),S:w("m"),F:w("k7?"),n:w("l4?"),T:w("h?"),i:w("D(dD?)?"),I:w("m?"),H:w("~")}})();(function constants(){var w=a.makeConstList
C.yo=new A.mB(0,"connectionAccepted")
C.yp=new A.mB(1,"unacceptedProtocolVersion")
C.yq=new A.mB(2,"identifierRejected")
C.aO=new A.mB(3,"brokerUnavailable")
C.yr=new A.mB(4,"badUsernameOrPassword")
C.ys=new A.mB(5,"notAuthorized")
C.cD=new A.mB(6,"noneSpecified")
C.On=w([C.yo,C.yp,C.yq,C.aO,C.yr,C.ys,C.cD],B.T("n<mB>"))
C.ST=new A.fm(0,"reserved1")
C.mU=new A.fm(1,"connect")
C.mX=new A.fm(2,"connectAck")
C.jd=new A.fm(3,"publish")
C.je=new A.fm(4,"publishAck")
C.jf=new A.fm(5,"publishReceived")
C.jg=new A.fm(6,"publishRelease")
C.jh=new A.fm(7,"publishComplete")
C.mY=new A.fm(8,"subscribe")
C.mZ=new A.fm(9,"subscribeAck")
C.yu=new A.fm(10,"unsubscribe")
C.mV=new A.fm(11,"unsubscribeAck")
C.jb=new A.fm(12,"pingRequest")
C.jc=new A.fm(13,"pingResponse")
C.mW=new A.fm(14,"disconnect")
C.SU=new A.fm(15,"reserved2")
C.OY=w([C.ST,C.mU,C.mX,C.jd,C.je,C.jf,C.jg,C.jh,C.mY,C.mZ,C.yu,C.mV,C.jb,C.jc,C.mW,C.SU],B.T("n<fm>"))
C.PB=w(["mqtt","mqttv3.1","mqttv3.11"],x.s)
C.Qj=w(["mqtt"],x.s)
C.cj=new A.zw(1,"disconnected")
C.yt=new A.zw(2,"connecting")
C.c0=new A.zw(3,"connected")
C.SQ=new A.zw(4,"faulted")
C.SR=new A.Hk(0,"unsolicited")
C.SS=new A.Hk(1,"solicited")
C.eC=new A.Hk(2,"none")
C.aU=new A.l4(0,"atMostOnce")
C.bL=new A.l4(1,"atLeastOnce")
C.eD=new A.l4(2,"exactlyOnce")
C.SV=new A.l4(3,"reserved1")
C.n_=new A.l4(4,"failure")
C.a5b=B.aJ("@")})();(function staticFields(){$.aZo=!1
$.aZq=0})();(function lazyInitializers(){var w=a.lazyFinal
w($,"bod","b5n",()=>new A.ap_())})()};
(a=>{a["noGtWdDDFpi3CjxbhkUDNpc1Oo8="]=a.current})($__dart_deferred_initializers__);