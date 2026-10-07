((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,A={ahh:function ahh(d){this.a=d},ahi:function ahi(d){this.a=d},
aZg(){var w=B.b([],x.r),v=$.cx,u=(v==null?$.cx=$.fu():v).fi("[DEFAULT]")
B.cH(u,$.f_(),!0)
v=B.u7(new B.ec(u))
v=new B.aim(v)
return new A.jm(v,w,$.as())},
jm:function jm(d,e,f){var _=this
_.a=d
_.c=_.b=null
_.d=!1
_.e=e
_.r=_.f=!1
_.K$=0
_.U$=f
_.al$=_.ai$=0},
apN:function apN(d,e){this.a=d
this.b=e},
apO:function apO(d,e){this.a=d
this.b=e},
a48:function a48(){},
VF:function VF(){},
apx:function apx(){},
apy:function apy(d,e,f){var _=this
_.as=d
_.a=null
_.b=e
_.d=$
_.e=null
_.f=f},
apD:function apD(){},
apE:function apE(d,e,f){this.a=d
this.b=e
this.c=f},
apF:function apF(d,e){this.a=d
this.b=e},
apG:function apG(d,e){this.a=d
this.b=e},
apz:function apz(){},
apA:function apA(d,e,f){this.a=d
this.b=e
this.c=f},
apB:function apB(d,e){this.a=d
this.b=e},
apC:function apC(d,e){this.a=d
this.b=e},
apH:function apH(d){this.a=d},
apI:function apI(d){this.a=d},
apJ:function apJ(d){this.a=d},
ayn:function ayn(d,e,f,g,h){var _=this
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
apw:function apw(d,e,f){var _=this
_.a=d
_.b=1883
_.c=e
_.d=!1
_.as=_.Q=_.z=_.y=null
_.at=0
_.ay=null
_.ch=f
_.k1=_.cx=_.CW=null},
bbF(d){var w,v
for(w=d.length,v=0;v<w;++v)if(d.charCodeAt(v)>127)throw B.f(B.ci("mqtt_client::MQTTEncoding: The input string has extended UTF characters, which are not supported"))},
aWQ(d){var w=new A.Sh()
w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation."
if(d!=null)w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation. Current state is "+d.H().split(".")[1]
return w},
ale(d){var w=new A.UM()
w.a="mqtt-client::InvalidHeaderException: "+d
return w},
aYv(d){var w=new A.UN()
w.a="mqtt-client::InvalidMessageException: "+d
return w},
va(d){var w=new A.W7()
w.a="mqtt-client::NoConnectionException: "+d
return w},
zw(d,e){var w=d.a
if((w.c&4)===0)w.t(0,e)
else A.az(y.a,!1)},
aZi(d,e){if((d.c&4)!==0){A.az("Guarded add - stream is closed - event not added",!1)
return}if(d.d==null)A.az("Guarded add - stream has no listeners - adding anyway",!1)
d.t(0,e)},
aZe(){var w=new A.Hh(),v=new A.iD(C.aU)
v.a=C.mU
w.a=v
v=A.aSo()
w.b=v
A.aSo()
w.c=new A.VI(v)
return w},
aSo(){var w=new A.VJ(C.aO,new A.e0())
w.hM()
return w},
bbH(d){var w,v=new A.fJ(new Uint8Array(0),0),u=0
do{w=d.h7()
v.ou(w);++u}while(u<=4&&(w&128)===128)
return v},
bbG(d){var w,v,u,t,s
for(w=B.l(d),v=new B.bR(d,d.gE(0),w.j("bR<aU.E>")),w=w.j("aU.E"),u=0,t=1;v.v();){s=v.d
u+=((s==null?w.a(s):s)&127)*t
t*=128}return u},
bbJ(d){var w,v,u,t,s,r
try{w=new A.iD(C.aU)
t=new A.iD(C.aU)
t.is(d)
w=t
if(d.a.b-d.b<w.e){d.b=0
s=A.aYv("Available bytes is less than the message size")
throw B.f(s)}s=A.bbI(w,d)
return s}catch(r){s=B.a0(r)
if(x.L.b(s)){v=s
u=B.ak(r)
B.fU(A.aYv("The data provided in the message stream was not a valid MQTT Message, exception is "+B.k(v)),u)}else throw r}},
bbI(d,e){var w,v,u,t
switch(d.a){case C.mU:w=new A.Hh()
w.a=d
v=new A.VJ(C.aO,new A.e0())
v.is(e)
w.b=v
A.aSo()
u=new A.VI(v)
u.sDf(A.qB(e))
t=v.d
t===$&&B.a()
if(t.c){u.b=A.qB(e)
u.c=A.qB(e)}if(v.d.r){t=D.c.fb(A.qB(e))
u.d=t}if(v.d.f){v=D.c.fb(A.qB(e))
u.f=v}w.c=u
break
case C.mX:w=new A.Hg()
w.a=d
w.SF(e)
v=new A.apL(C.aO,new A.e0())
v.is(e)
w.b=v
break
case C.jd:w=new A.v5()
w.a=d
w.SF(e)
v=new A.VS(w.a,C.aO,new A.e0())
v.hM()
v.is(e)
w.b=v
u=w.a
t=new A.VP(u,v)
t.c=e.aIT(u.e-v.a)
w.c=t
break
case C.je:w=new A.zx()
w.a=d
v=new A.VN(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
break
case C.jh:w=new A.zy()
w.a=d
v=new A.VO(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
break
case C.jf:w=new A.zz()
w.a=d
v=new A.VQ(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
break
case C.jg:w=new A.zA()
w.a=d
v=new A.VR(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
break
case C.mY:w=new A.Hn()
w.a=d
d.c=C.bL
v=new A.VU(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
v=new A.VT(v,d,B.o(x.T,x.n))
v.is(e)
w.c=v
break
case C.mZ:w=new A.Hm()
w.a=d
v=new A.apQ(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
v=new A.apP(v,d,B.b([],x.v))
v.is(e)
w.c=v
break
case C.yu:w=new A.VV()
w.a=d
v=new A.apW(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
v=new A.apV(v,d,B.b([],x.s))
v.is(e)
w.c=v
break
case C.mV:w=new A.Ho()
w.a=d
v=new A.apU(C.aO,new A.e0())
v.hM()
v.ny(e)
w.b=v
break
case C.jb:w=new A.Hk()
w.a=d
break
case C.jc:w=new A.Hl()
w.a=d
break
case C.mW:w=new A.Hi()
w.a=d
break
default:throw B.f(A.ale("The Message Type specified ("+d.k(0)+".messageType) is not a valid MQTT Message type or currently not supported."))}return w},
aZh(d){var w,v,u,t
for(w=B.l(d),v=new B.bR(d,d.gE(0),w.j("bR<aU.E>")),w=w.j("aU.E"),u="";v.v();u=t){t=v.d
if(t==null)t=w.a(t)
t=u+"<"+B.k(t)+">"}return u.charCodeAt(0)==0?u:u},
bbK(d){var w,v
try{w=D.an.fk(d.en(d))
return w}catch(v){return""}},
aZj(){var w=new A.Hn(),v=new A.iD(C.aU)
v.a=C.mY
w.a=v
v.c=C.bL
v=new A.VU(C.aO,new A.e0())
v.hM()
w.b=v
w.c=new A.VT(null,null,B.o(x.T,x.n))
return w},
aSO(d){var w=new A.Xg(d)
w.Tg(d,B.b([A.b3L(),A.b3K(),A.blc()],x.x))
return w},
bcU(d){var w=d.a
if(D.c.p(w,"#")||D.c.p(w,"+"))throw B.f(B.ci("mqtt_client::PublicationTopic: Cannot publish to a topic that contains MQTT topic wildcards (# or +)"))},
aT6(){var w=x.y
return new A.AZ(B.b([],w),B.b([],x.p),B.b([],w),C.n_,A.aT7("rawtopic"),new A.Rx(x.Q))},
aT7(d){var w=new A.Zl(d)
w.Tg(d,B.b([A.b3L(),A.b3K(),A.ble(),A.bld()],x.x))
return w},
bec(d){var w=d.a
if(D.c.p(w,"#")&&!D.c.oY(w,"#"))throw B.f(B.ci("mqtt_client::SubscriptionTopic: The rawTopic wildcard # can only be present at the end of a topic"))
if(w.length>1&&D.c.oY(w,"#")&&!D.c.oY(w,"/#"))throw B.f(B.ci("mqtt_client::SubscriptionTopic: Topics using the # wildcard longer than 1 character must be immediately preceeded by a the rawTopic separator /"))},
beb(d){var w=d.b
w===$&&B.a()
if(D.b.eu(w,new A.ayi()))throw B.f(B.ci("mqtt_client::SubscriptionTopic: rawTopic Fragment contains a wildcard but is more than one character long"))},
beQ(d){var w=d.a.length
if(w>65535)throw B.f(B.ci("mqtt_client::Topic: The length of the supplied rawTopic ("+w+") is longer than the maximum allowable (65535)"))},
beR(d){if(d.a.length===0)throw B.f(B.ci("mqtt_client::Topic: rawTopic must contain at least one character"))},
qC(d,e){d.jG(new A.e0().lq(e))},
qB(d){var w,v=d.nx(2)
if(v.b<2)B.S(B.ci("mqtt_client::MQTTEncoding: Length byte array must comprise 2 bytes"))
w=d.nx((v.ga2(v)<<8>>>0)+v.i(0,1))
return D.dX.bN(w.en(w))},
az(d,e){},
apX(d){switch(d){case 0:return C.aU
case 1:return C.bL
case 2:return C.eD
case 128:return C.n_
default:return C.ST}},
Hj:function Hj(d,e){this.a=d
this.b=e},
zv:function zv(d,e){this.a=d
this.b=e},
VK:function VK(){},
VL:function VL(){},
VM:function VM(){var _=this
_.a=$
_.b=0
_.f=_.e=_.d=_.c=null
_.w=_.r=0
_.x=null
_.y=$
_.z=!1
_.as=_.Q=0},
e0:function e0(){},
RY:function RY(){this.a=$},
Sh:function Sh(){this.a=$},
UD:function UD(){this.a=$},
UM:function UM(){this.a=$},
UN:function UN(){this.a=$},
UO:function UO(){this.a=$},
W7:function W7(){this.a=$},
VH:function VH(d){var _=this
_.c=_.b=_.a=!1
_.d=d
_.r=_.f=_.e=!1},
Hh:function Hh(){this.b=null
this.c=$
this.a=null},
VI:function VI(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.e=""
_.f=null},
mB:function mB(d,e){this.a=d
this.b=e},
VJ:function VJ(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hg:function Hg(){this.b=$
this.a=null},
apL:function apL(d,e){var _=this
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
Hi:function Hi(){this.a=null},
iD:function iD(d){var _=this
_.a=null
_.b=!1
_.c=d
_.d=!1
_.e=0},
dD:function dD(){},
fm:function fm(d,e){this.a=d
this.b=e},
apM:function apM(){},
apY:function apY(){},
Hk:function Hk(){this.a=null},
Hl:function Hl(){this.a=null},
v5:function v5(){this.b=null
this.c=$
this.a=null},
VP:function VP(d,e){this.a=d
this.b=e
this.c=$},
VS:function VS(d,e,f){var _=this
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
zx:function zx(){this.b=$
this.a=null},
VN:function VN(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
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
VQ:function VQ(d,e){var _=this
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
Hn:function Hn(){var _=this
_.b=null
_.c=$
_.a=_.d=null},
VT:function VT(d,e,f){this.a=d
this.b=e
this.c=f},
apT:function apT(d){this.a=d},
apR:function apR(d,e){this.a=d
this.b=e},
apS:function apS(d){this.a=d},
VU:function VU(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hm:function Hm(){this.b=null
this.c=$
this.a=null},
apP:function apP(d,e,f){this.a=d
this.b=e
this.c=f},
apQ:function apQ(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
VV:function VV(){this.b=null
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
Ho:function Ho(){this.b=$
this.a=null},
apU:function apU(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Hf:function Hf(){},
k7:function k7(d,e,f){this.a=d
this.b=e
this.c=f},
zq:function zq(d){this.a=d},
y5:function y5(d){this.a=d},
qy:function qy(d,e){this.a=d
this.b=e},
xx:function xx(){},
At:function At(d){this.a=d},
yn:function yn(){},
ym:function ym(){},
aoU:function aoU(){this.a=0},
l4:function l4(d,e){this.a=d
this.b=e},
oj:function oj(d,e){this.b=d
this.$ti=e},
Xg:function Xg(d){this.a=d
this.b=$},
Xh:function Xh(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=!1
_.x=j
_.y=k},
AZ:function AZ(d,e,f,g,h,i){var _=this
_.b=null
_.c=!1
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i},
ayj:function ayj(){},
ayk:function ayk(){},
Zl:function Zl(d){this.a=d
this.b=$},
ayi:function ayi(){},
Zm:function Zm(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.x=_.w=_.r=null
_.y=!0
_.z=i
_.Q=j},
oX:function oX(){},
zu:function zu(d){this.a=d
this.b=0},
apK:function apK(){this.a=null},
VG:function VG(d){var _=this
_.a=d
_.c=_.b=$
_.d=!1},
Rx:function Rx(d){this.$ti=d},
Wd:function Wd(){},
Eg:function Eg(){},
Bf:function Bf(){},
a3l:function a3l(){},
fJ:function fJ(d,e){this.a=d
this.b=e}},C,E
J=c[1]
B=c[0]
D=c[2]
A=a.updateHolder(c[7],A)
C=c[29]
E=c[16]
A.ahh.prototype={
ra(d){var w,v=this.a,u=B.l(v)
if(B.cA(d)===C.a5b)return d.j("c2<0>").a(new B.cs(v,u.j("cs<1>")))
else{u=u.j("cs<1>")
w=u.j("Pk<c2.T>")
return new B.Ef(new B.Pk(new A.ahi(d),new B.cs(v,u),w),w.j("@<c2.T>").aG(d).j("Ef<1,2>"))}}}
A.jm.prototype={
gF1(){return this.f},
gaFH(){return this.r},
ES(d){return this.aEX(d)},
aEX(a0){var w=0,v=B.L(x.H),u,t=2,s=[],r=[],q=this,p,o,n,m,l,k,j,i,h,g,f,e,d
var $async$ES=B.G(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:if(q.f||q.r){w=1
break}q.r=!0
D.b.M(q.e)
if(!q.d)q.aH()
l="flutter_"+a0+"_"+Date.now()
k="inbody/users/"+a0
p=k+"/data"
o=k+"/status"
k=q.b
if(k==null){j=new A.apw("wss://broker.emqx.io/mqtt",l,new A.k7(C.cj,C.cD,C.eC))
j.b=8084
j.z=C.Qh
q.b=j
k=j}k.at=20
i=A.aZe()
k=i.c
k===$&&B.a()
k.sDf(l)
k=i.b.d
k===$&&B.a()
k.b=!0
k.c=!0
h=i.c
h.b=o
h.c="offline"
k.d=C.bL
k.e=!0
q.b.sMW(i)
k=q.b
k.cx=new A.apN(q,a0)
t=4
w=7
return B.F(k.Dj(),$async$ES)
case 7:q.f=!0
k=q.b
h=p
if(k.ga2q().a!==C.c0){g=k.y
B.S(A.aWQ(g==null?null:g.cy.a))}k=k.Q
if(k.aKl(h)==null)k.a2M(h,C.bL)
B.k(p)
f=new A.apK()
f.a=new A.fJ(new Uint8Array(0),0)
n=f
n.axm("online")
k=q.b
k.toString
k.aIt(o,C.bL,n.a,!0)
k=q.c
if(k!=null)k.aB()
k=q.b.Q
if(k==null)k=null
else{k=k.Q
k=x.P.a(new B.cs(k,B.l(k).j("cs<1>")))}q.c=k.e7(new A.apO(q,a0))
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
if(!q.d)q.aH()
w=r.pop()
break
case 6:case 1:return B.J(u,v)
case 2:return B.I(s.at(-1),v)}})
return B.K($async$ES,v)},
Br(d,e){return this.amN(d,e)},
amN(d,e){var w=0,v=B.L(x.H),u=1,t=[],s=this,r,q,p,o,n
var $async$Br=B.G(function(f,g){if(f===1){t.push(g)
w=u}for(;;)switch(w){case 0:u=3
r=D.e8.a2T(d,null)
q=E.aYq("mqtt_"+Date.now(),r)
D.b.e4(s.e,0,q)
if(!s.d)s.aH()
w=6
return B.F(s.a.CN(e,q),$async$Br)
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
aBk(){var w=this,v=w.c
if(v!=null)v.aB()
w.c=null
v=w.b
if(v!=null)v.IY(!1)
w.f=!1
if(!w.d)w.aH()},
m(){var w,v=this
v.d=!0
w=v.c
if(w!=null)w.aB()
w=v.b
if(w!=null)w.IY(!1)
v.dC()},
$ia9:1}
A.a48.prototype={}
A.VF.prototype={
pi(d){var w,v,u,t,s,r,q,p,o,n=this,m=y.a
A.az("MqttBrowserConnection::_onData",!1)
u=J.dK(d,0,null)
if(u.length===0){A.az("MqttBrowserConnection::_ondata - Error - 0 byte message",!1)
return}t=n.d
t===$&&B.a()
t.a.O(0,u)
for(t=x.L,s=n.f;r=n.d,r.aFJ();){w=!0
v=null
try{v=A.bbJ(r)}catch(q){if(t.b(B.a0(q))){A.az("MqttBrowserConnection::_ondata - message is not yet valid, waiting for more data ...",!1)
w=!1}else throw q}if(!w){n.d.b=0
return}if(w){r=n.d
p=r.b
o=r.a
if(p<o.b){B.dE(0,p,o.gE(0),null,null)
if(p>0)o.In(o,0,p)}else o.sE(0,0)
r.b=0
A.az("MqttBrowserConnection::_onData - message received ",v)
if(v.a.a===C.mX){r=v
p=s.a
if((p.c&4)===0){if(!p.gmL())B.S(p.mC())
p.lJ(new A.y5(r))}else A.az(m,!1)}else{r=v
p=s.a
if((p.c&4)===0){if(!p.gmL())B.S(p.mC())
p.lJ(new A.zq(r))}else A.az(m,!1)}A.az("MqttBrowserConnection::_onData - message available event fired",!1)}else A.az("MqttBrowserConnection::_onData - WARN - message available event not fired, event bus is closed",!1)}},
a_x(){var w,v,u
this.vB()
A.az("MqttBrowserConnection::_startListening",!1)
try{this.aHr()}catch(v){u=B.a0(v)
if(x.L.b(u)){w=u
A.az("MqttBrowserConnection::_startListening - exception raised "+B.k(w),!1)}else throw v}}}
A.apx.prototype={}
A.apy.prototype={
xx(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b1(new B.ab($.ah,x.w),x.l)
A.az("MqttBrowserWsConnection::connect - entered",!1)
w=null
try{w=B.kn(d)}catch(p){if(x.L.b(B.a0(p))){v=B.ak(p)
u="MqttBrowserWsConnection::connect - The URI supplied for the WS connection is not valid - "+d
B.fU(A.va(u),v)}else throw p}if(w.gjK()!=="ws"&&w.gjK()!=="wss")throw B.f(A.va("MqttBrowserWsConnection::connect - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.Q5(e)
t=w.gqg()
A.az("MqttBrowserWsConnection::connect -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a1<1,h>")
m=B.V(new B.a1(m,new A.apD(),l),l.j("ad.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.zu(new A.fJ(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kv(s,"open",new A.apE(o,k,j),!1,n)
o.b=B.kv(s,"close",new A.apF(o,j),!1,n)
o.a=B.kv(s,"error",new A.apG(o,j),!1,n)}catch(p){if(x.L.b(B.a0(p))){r=B.ak(p)
q="MqttBrowserWsConnection::connect - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fU(A.va(q),r)}else throw p}A.az("MqttBrowserWsConnection::connect - connection is waiting",!1)
return j.a},
azh(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b1(new B.ab($.ah,x.w),x.l)
A.az("MqttBrowserWsConnection::connectAuto - entered",!1)
w=null
try{w=B.kn(d)}catch(p){if(x.L.b(B.a0(p))){v=B.ak(p)
u="MqttBrowserWsConnection::connectAuto - The URI supplied for the WS connection is not valid - "+d
B.fU(A.va(u),v)}else throw p}if(w.gjK()!=="ws"&&w.gjK()!=="wss")throw B.f(A.va("MqttBrowserWsConnection::connectAuto - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.Q5(e)
t=w.gqg()
A.az("MqttBrowserWsConnection::connectAuto -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a1<1,h>")
m=B.V(new B.a1(m,new A.apz(),l),l.j("ad.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.zu(new A.fJ(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kv(s,"open",new A.apA(o,k,j),!1,n)
o.b=B.kv(s,"close",new A.apB(o,j),!1,n)
o.a=B.kv(s,"error",new A.apC(o,j),!1,n)}catch(p){if(x.L.b(B.a0(p))){r=B.ak(p)
q="MqttBrowserWsConnection::connectAuto - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fU(A.va(q),r)}else throw p}A.az("MqttBrowserWsConnection::connectAuto - connection is waiting",!1)
return j.a},
vB(){var w,v,u
for(w=this.b,v=w.length,u=0;u<w.length;w.length===v||(0,B.y)(w),++u)w[u].aB()
D.b.M(w)},
Dg(){var w=this.a
if(w!=null)w.close()},
aHr(){var w,v=this,u=v.a
if(u==null)throw B.f(B.aA("webSocket is null"))
w=x.m
return B.b([B.kv(u,"close",new A.apH(v),!1,w),B.kv(u,"message",new A.apI(v),!1,w),B.kv(u,"error",new A.apJ(v),!1,w)],x.d)}}
A.ayn.prototype={
ur(d,e,f){return this.aFf(d,e,f)},
aFf(d,e,a0){var w=0,v=B.L(x.e),u,t=2,s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f
var $async$ur=B.G(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect entered",!1)
q=x.L
p=r.as
o=x.d
n=x.g
m=x.Y
l=r.z
k=0
case 3:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - initiating connection try "+k+", auto reconnect in progress "+r.f,!1)
j=r.cy
j.a=C.yt
j.b=C.cD
if(!r.f){i=new A.apy(C.Pz,B.b([],o),p)
h=r.at
if(h!=null)i.as=h
i.e=r.b
r.ay=i}t=7
w=!r.f?10:12
break
case 10:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connect",!1)
j=r.ay
j===$&&B.a()
w=13
return B.F(j.xx(d,e),$async$ur)
case 13:w=11
break
case 12:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connectAuto",!1)
j=r.ay
j===$&&B.a()
w=14
return B.F(j.azh(d,e),$async$ur)
case 14:case 11:t=2
w=9
break
case 7:t=6
f=s.pop()
if(q.b(B.a0(f)))if(r.f)A.az("SynchronousMqttBrowserConnectionHandler::internalConnect exception thrown during auto reconnect - ignoring",!1)
else throw f
else throw f
w=9
break
case 6:w=2
break
case 9:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - connection complete",!1)
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect sending connect message",!1)
r.kI(a0)
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - pre sleep, state = "+r.cy.k(0),!1)
j=r.Q
j===$&&B.a()
if(!j.d){j.b=new B.b1(new B.ab($.ah,n),m)
j.c=B.cg(B.eb(0,j.a,0),j.gavz())
j.d=!0}j=j.b
j===$&&B.a()
w=15
return B.F(j.a,$async$ur)
case 15:++k
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - post sleep, state = "+r.cy.k(0),!1)
if(r.cy.a!==C.c0)if(!r.f)A.az("SynchronousMqttBrowserConnectionHandler::internalConnect failed, attempt "+k,!1)
j=r.cy.a!==C.c0
case 4:if(j&&k<l){w=3
break}case 5:if(j)if(!r.f){A.az("SynchronousMqttBrowserConnectionHandler::internalConnect failed",!1)
q=r.cy.b
l="The maximum allowed connection attempts ({"+l
if(q===C.cD)throw B.f(A.va(l+"}) were exceeded. The broker is not responding to the connection request message (Missing Connection Acknowledgement?"))
else throw B.f(A.va(l+"}) were exceeded. The broker is not responding to the connection request message correctly The return code is "+B.k(q)))}A.az("SynchronousMqttBrowserConnectionHandler::internalConnect exited with state "+r.cy.k(0),!1)
r.cx=!0
u=r.cy
w=1
break
case 1:return B.J(u,v)
case 2:return B.I(s.at(-1),v)}})
return B.K($async$ur,v)}}
A.apw.prototype={
Dj(){var w=0,v=B.L(x.F),u,t=this,s,r,q
var $async$Dj=B.G(function(d,e){if(d===1)return B.I(e,v)
for(;;)switch(w){case 0:t.d=$.aZd=!0
s=new A.ahh(new B.er(null,null,x.J))
t.k1=s
s.ra(x.u).e7(t.gaBn())
r=t.k1
if(r!=null)r.ra(x.o).e7(t.gaBl())
r=t.k1
q=new A.ayn(3,r,B.o(x.q,x.i),B.b([],x.B),new A.k7(C.cj,C.cD,C.eC))
q.Q=new A.VG(5000)
r.ra(x.h).e7(q.gaxX())
r.ra(x.W).e7(q.gaGG())
r.ra(x._).e7(q.gazf())
t.y=q
w=3
return B.F(t.ab9(null,null),$async$Dj)
case 3:u=e
w=1
break
case 1:return B.J(u,v)}})
return B.K($async$Dj,v)}}
A.Hj.prototype={
H(){return"MqttDisconnectionOrigin."+this.b}}
A.zv.prototype={
H(){return"MqttConnectionState."+this.b}}
A.VK.prototype={
Pn(){var w=this
w.vB()
w.Dg()
w.a=null
if(w.e!=null){A.az("MqttConnectionBase::_onDone - calling disconnected callback",!1)
w.e.$0()}}}
A.VL.prototype={
xy(d,e,f){return this.azd(d,e,f)},
azd(d,e,f){var w=0,v=B.L(x.e),u,t=2,s=[],r=this,q,p,o
var $async$xy=B.G(function(g,h){if(g===1){s.push(h)
w=t}for(;;)switch(w){case 0:r.r=d
r.w=e
A.az("MqttConnectionHandlerBase::connect - server "+d+", port "+e,!1)
r.x=f
t=4
w=7
return B.F(r.ur(d,e,f),$async$xy)
case 7:q=r.cy
u=q
w=1
break
t=2
w=6
break
case 4:t=3
o=s.pop()
if(x.L.b(B.a0(o))){r.cy.a=C.SO
throw o}else throw o
w=6
break
case 3:w=2
break
case 6:case 1:return B.J(u,v)
case 2:return B.I(s.at(-1),v)}})
return B.K($async$xy,v)},
D2(d){return this.axY(d)},
axY(d){var w=0,v=B.L(x.H),u,t=this,s,r
var $async$D2=B.G(function(e,f){if(e===1)return B.I(f,v)
for(;;)switch(w){case 0:A.az("MqttConnectionHandlerBase::autoReconnect entered",!1)
s=t.f
if(s){w=1
break}t.f=!0
s=t.ay
s===$&&B.a()
s.vB()
s.Dg()
s.a=null
t.ay.e=null
A.az("MqttConnectionHandlerBase::autoReconnect - attempting reconnection",!1)
s=t.r
s.toString
r=t.w
r.toString
w=3
return B.F(t.xy(s,r,t.x),$async$D2)
case 3:r=f
t.cy=r
t.f=!1
s=t.as
if(r.a===C.c0){t.ay.e=t.b
s.toString
A.zw(s,new A.At(!0))
A.az("MqttConnectionHandlerBase::autoReconnect - auto reconnect complete",!1)}else{A.az("MqttConnectionHandlerBase::autoReconnect - auto reconnect failed - re trying",!1)
s.toString
A.zw(s,new A.xx())}case 1:return B.J(u,v)}})
return B.K($async$D2,v)},
kI(d){var w,v,u,t,s
A.az("MqttConnectionHandlerBase::sendMessage",!1)
w=this.cy.a
if(w===C.c0||w===C.yt){v=new A.zu(new A.fJ(new Uint8Array(0),0))
d.i7(v)
w=v.a.b
if(0<=w)v.b=0
else v.b=w
A.az("MqttConnectionHandlerBase::sendMessage = message is "+d.k(0),!1)
w=this.ay
w===$&&B.a()
u=J.td(D.l.gbe(v.nx(v.a.b).a),0,null)
w=w.a
if(w!=null){t=B.a6(u)
t.toString
w.send(t)}for(w=this.CW,t=w.length,s=0;s<w.length;w.length===t||(0,B.y)(w),++s)w[s].$1(d)}else A.az("MqttConnectionHandlerBase::sendMessage - not connected",!1)},
aGH(d){var w,v=d.a,u=v.a.a
A.az("MqttConnectionHandlerBase::messageAvailable - message type is "+B.k(u),!1)
u.toString
w=this.ch.i(0,u)
if(w!=null)w.$1(v)
else A.az("MqttConnectionHandlerBase::messageAvailable - WARN - no registered callback for this message type",!1)},
aze(d){var w,v,u,t,s=this,r=y.B
A.az("MqttConnectionHandlerBase::_connectAckProcessor",!1)
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
if(v){A.az("MqttConnectionHandlerBase::_connectAckProcessor connection rejected",!1)
v=s.cy
u=w.b
u===$&&B.a()
v.b=u.f
A.az(r,!1)
s.cy.a=C.cj}else{A.az("MqttConnectionHandlerBase:_connectAckProcessor - state = connected",!1)
v=s.cy
v.a=C.c0
v.b=C.yo}}catch(t){if(x.L.b(B.a0(t))){A.az(r,!1)
s.cy.a=C.cj}else throw t}A.az("MqttConnectionHandlerBase:: cancelling connect timer",!1)
v=s.Q
v===$&&B.a()
if(v.d){u=v.c
u===$&&B.a()
u.aB()
v.d=!1
v=v.b
v===$&&B.a()
v.ew()}return!0},
azg(d){var w=d.a
w.toString
this.aze(w)}}
A.VM.prototype={
aIf(){var w,v,u,t,s,r=this
A.az("MqttConnectionKeepAlive::pingRequired",!1)
if(r.z)return!1
else r.z=!0
w=!1
u=new A.Hk()
t=new A.iD(C.aU)
t.a=C.jb
u.a=t
v=u
t=r.y
t===$&&B.a()
if(t.cy.a===C.c0){A.az("MqttConnectionKeepAlive::pingRequired - sending ping request",!1)
try{r.y.kI(v)
w=!0
r.as=Date.now()}catch(s){A.az("MqttConnectionKeepAlive::pingRequired - exception occurred",!1)}}else A.az("MqttConnectionKeepAlive::pingRequired - NOT sending ping - not connected",!1)
A.az("MqttConnectionKeepAlive::pingRequired - restarting ping timer",!1)
t=r.a
t===$&&B.a()
r.c=B.cg(B.eb(0,t,0),r.ga6f())
if(r.b!==0){t=r.d
if(t==null){A.az("MqttConnectionKeepAlive::pingRequired - starting disconnect timer",!1)
if(w)r.d=B.cg(B.eb(0,r.b,0),r.ga5Q())
else r.a5P()}else{t=t.b
if(t==null)if(w){A.az("MqttConnectionKeepAlive::pingRequired - restarting disconnect timer",!1)
r.d=B.cg(B.eb(0,r.b,0),r.ga5Q())}else r.a5P()
else A.az("MqttConnectionKeepAlive::pingRequired - disconnect timer is active, not restarting",!1)}}r.z=!1
return w},
aIe(d){var w,v=this
A.az("MqttConnectionKeepAlive::pingRequestReceived",!1)
if(v.z)return!1
else v.z=!0
d=new A.Hl()
w=new A.iD(C.aU)
w.a=C.jc
d.a=w
w=v.y
w===$&&B.a()
w.kI(d)
v.z=!1
return!0},
aIh(d){var w,v,u,t=this
A.az("MqttConnectionKeepAlive::pingResponseReceived",!1)
w=Date.now()-t.as
t.r=w
v=++t.Q
u=t.w
t.w=u+D.d.kL(w-u,v)
w=t.d
if(w!=null)w.aB()
return!0},
aGJ(d){return!0},
aH_(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.c0){A.az("MqttConnectionKeepAlive::noPingResponseReceived - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.zw(w,new A.yn())
A.az("MqttConnectionKeepAlive::noPingResponseReceived - OK - disconnect event fired",!1)}else A.az("MqttConnectionKeepAlive::noPingResponseReceived - ERROR - disconnect event not fired, no event handler",!1)}else A.az("MqttConnectionKeepAlive::noPingResponseReceived - not disconnecting, not connected",!1)},
a5P(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.c0){A.az("MqttConnectionKeepAlive::noMessageSent - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.zw(w,new A.ym())
A.az("MqttConnectionKeepAlive::noMessageSent - OK - disconnect event fired",!1)}else A.az("MqttConnectionKeepAlive::noMessageSent - ERROR - disconnect event not fired, no event handler",!1)}else A.az("MqttConnectionKeepAlive::noMessageSent - not disconnecting, not connected",!1)}}
A.e0.prototype={
lq(d){var w,v,u
A.bbF(d)
w=D.av.bN(d)
v=w.length
if(v>65535)throw B.f(B.ci("MqttUtf8Encoding::toUtf8 -  UTF8 string length is invalid, length is "+v))
u=new A.fJ(new Uint8Array(0),0)
u.ou(v>>>8)
u.ou(v&255)
u.O(0,w)
return u}}
A.RY.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.Sh.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.UD.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.UM.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.UN.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.UO.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.W7.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibj:1}
A.VH.prototype={
azi(){var w=this,v=w.a?1:0,u=w.b?1:0,t=w.c?1:0,s=w.d,r=w.e?1:0,q=w.f?1:0,p=w.r?1:0
return(v|u<<1|t<<2|s.a<<3|r<<5|q<<6|p<<7)>>>0},
k(d){var w=this
return"Connect Flags: Reserved1="+w.a+", CleanStart="+w.b+", WillFlag="+w.c+", WillQos="+w.d.k(0)+", WillRetain="+w.e+", PasswordFlag="+w.f+", UserNameFlag="+w.r}}
A.Hh.prototype={
a1R(d,e){return this},
i7(d){var w,v,u,t,s,r,q,p=this,o=p.a
o.toString
w=new A.e0().lq(p.b.b).b
v=p.c
v===$&&B.a()
u=new A.e0()
t=u.lq(v.e).b
s=v.a
r=s.d
r===$&&B.a()
if(r.c){r=v.b
r.toString
r=u.lq(r).b
q=v.c
q.toString
t=t+r+u.lq(q).b}if(s.d.r){r=v.d
r.toString
t+=u.lq(r).b}if(s.d.f){v=v.f
v.toString
t+=u.lq(v).b}o.kH(w+1+1+2+t,d)
o=p.b
A.qC(d,o.b)
d.nG(o.c)
v=o.d
v===$&&B.a()
d.nG(v.azi())
d.mu(o.e)
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
A.VI.prototype={
sDf(d){var w,v=d.length
if(v>65535){w=new A.RY()
w.a="mqtt-client::ClientIdentifierException: Client id "+d+" is too long at "+v+", Maximum ClientIdentifier length is 65535"
throw B.f(w)}this.e=d},
k(d){return y.h+this.e}}
A.mB.prototype={
H(){return"MqttConnectReturnCode."+this.b}}
A.VJ.prototype={
is(d){var w=this
w.aIU(d)
w.aIV(d)
w.aIM(d)
w.aIR(d)},
k(d){var w=this,v=w.b,u=w.c,t=w.d
t===$&&B.a()
return"Connect Variable Header: ProtocolName="+v+", ProtocolVersion="+u+", ConnectFlags="+t.k(0)+", KeepAlive="+w.e}}
A.Hg.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b
if(w.y)d.nG(1)
else d.nG(0)
d.nG(w.f.a)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.t+v.y+"}, ReturnCode={"+v.f.k(0)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.apL.prototype={
is(d){d.h7()
this.aIW(d)},
k(d){return y.t+this.y+"}, ReturnCode={"+this.f.k(0)+"}"}}
A.Hi.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.iD.prototype={
kH(d,e){var w,v,u,t,s,r=this
r.e=d
w=new A.fJ(new Uint8Array(0),0)
v=r.a.a
u=r.b?1:0
t=r.c
s=r.d?1:0
w.ou((v<<4>>>0)+(u<<3>>>0)+(t.a<<1>>>0)+s)
w.O(0,r.a8w())
e.jG(w)},
is(d){var w,v,u,t,s,r=this,q="The header being processed contained an invalid size byte pattern. Message size must take a most 4 bytes, and the last byte must have bit 8 set to 0."
if(d.a.b<2){d.b=0
throw B.f(A.ale("The supplied header is invalid. Header must be at least 2 bytes long."))}u=d.h7()
r.d=(u&1)===1
r.c=A.apX(u>>>1&3)
r.b=(u>>>3&1)===1
r.a=C.OW[u>>>4&15]
try{r.e=A.bbG(A.bbH(d))}catch(t){s=B.a0(t)
if(x.L.b(s)){w=B.ak(t)
B.fU(A.ale(q),w)}else if(x.C.b(s)){v=B.ak(t)
B.fU(A.ale(q),v)}else throw t}},
a8w(){var w,v,u=new A.fJ(new Uint8Array(0),0),t=this.e
do{w=D.d.aX(t,128)
t=D.d.bT(t,128)
v=t>0
u.ou(v?(w|128)>>>0:w)}while(v)
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
A.apM.prototype={}
A.apY.prototype={
hM(){this.b="MQIsdp"
this.c=3
this.d=new A.VH(C.aU)},
aIU(d){var w=A.qB(d)
this.b=w
this.a=this.a+(w.length+2)},
aIV(d){this.c=d.h7();++this.a},
aIR(d){this.e=d.a6z()
this.a+=2},
aIW(d){this.f=C.Ol[d.h7()];++this.a},
aIX(d){var w=A.qB(d)
this.r=w
this.a=w.length+2},
ny(d){this.w=d.a6z()
this.a+=2},
aIM(d){var w=new A.VH(C.aU),v=d.h7()
w.a=(v&1)===1
w.b=(v&2)===2
w.c=(v&4)===4
w.d=A.apX(D.d.aI(v,3)&3)
w.e=(v&32)===32
w.f=(v&64)===64
w.r=(v&128)===128
this.d=w;++this.a},
gE(d){return this.a}}
A.Hk.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.Hl.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.v5.prototype={
i7(d){var w,v,u=this,t=u.b,s=new A.e0().lq(t.r).b
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
d.mu(t)}t=u.c.c
t===$&&B.a()
d.jG(t)},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=u.c
u===$&&B.a()
u=w+(v+"\n")+("Payload: {"+u.b+" bytes={"+A.aZh(u)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.VP.prototype={
k(d){var w=this.c
w===$&&B.a()
return"Payload: {"+w.b+" bytes={"+A.aZh(w)}}
A.VS.prototype={
is(d){var w
this.aIX(d)
w=this.y.c
if(w===C.bL||w===C.eD)this.ny(d)},
k(d){return"Publish Variable Header: TopicName={"+this.r+"}, MessageIdentifier={"+B.k(this.w)+"}, VH Length={"+this.a+"}"}}
A.zx.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mu(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.p+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VN.prototype={
k(d){return y.p+B.k(this.w)+"}"}}
A.zy.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mu(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.w+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VO.prototype={
k(d){return y.w+B.k(this.w)+"}"}}
A.zz.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mu(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.g+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VQ.prototype={
k(d){return y.g+B.k(this.w)+"}"}}
A.zA.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mu(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.i+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.VR.prototype={
k(d){return y.i+B.k(this.w)+"}"}}
A.Hn.prototype={
i7(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kH(2+w.H_(),d)
w=v.b.w
w.toString
d.mu(w)
v.c.i7(d)},
aK5(d){var w
this.d=d
w=this.c
w===$&&B.a()
w.c.h(0,d,C.aU)
return this},
axK(d){var w=this,v=w.c
v===$&&B.a()
if(v.c.G(w.d))w.c.c.h(0,w.d,d)
return w},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.VT.prototype={
i7(d){this.c.am(0,new A.apT(d))},
is(d){var w,v,u,t=this.b.e-this.a.a
for(w=this.c,v=0;v<t;){u=A.qB(d)
v+=u.length+3
w.h(0,u,A.apX(d.h7()))}},
H_(){var w={}
w.a=0
this.c.am(0,new A.apR(w,new A.e0()))
return w.a},
k(d){var w=new B.cQ(""),v=this.c
w.a="Payload: Subscription [{"+v.a+"}]\n"
v.am(0,new A.apS(w))
v=w.a
return v.charCodeAt(0)==0?v:v}}
A.VU.prototype={
k(d){return"Subscribe Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Hm.prototype={
i7(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kH(2+w.c.length,d)
w=v.b.w
w.toString
d.mu(w)
v.c.i7(d)},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.apP.prototype={
i7(d){var w,v,u
for(w=this.c,v=w.length,u=0;u<w.length;w.length===v||(0,B.y)(w),++u)d.nG(w[u].a)},
is(d){var w,v,u=this.b.e-this.a.a
for(w=this.c,v=0;v<u;){++v
w.push(A.apX(d.h7()))}},
k(d){var w,v=this.c,u=v.length,t="Payload: Qos grants [{"+u+"}]\n"
for(w=0;w<v.length;v.length===u||(0,B.y)(v),++w)t+="{{ Grant={"+v[w].k(0)+"} }}\n"
return t.charCodeAt(0)==0?t:t}}
A.apQ.prototype={
k(d){return"SubscribeAck Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.VV.prototype={
i7(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kH(2+w.H_(),d)
w=v.b.w
w.toString
d.mu(w)
D.b.am(v.c.c,d.gaKM())},
k(d){var w=this.iD(0),v=J.bg(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.apV.prototype={
is(d){var w,v,u,t=this.b.e-this.a.a
for(w=this.c,v=0;v<t;){u=A.qB(d)
v+=u.length+2
w.push(u)}},
H_(){var w,v,u,t,s=new A.e0()
for(w=this.c,v=w.length,u=0,t=0;t<w.length;w.length===v||(0,B.y)(w),++t)u+=s.lq(w[t]).b
return u},
k(d){var w,v=this.c,u=v.length,t="Payload: Unsubscription [{"+u+"}]\n"
for(w=0;w<u;++w)t+="{{ Topic={"+v[w]+"}}\n"
return t.charCodeAt(0)==0?t:t}}
A.apW.prototype={
k(d){return"Unsubscribe VariableHeader Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Ho.prototype={
i7(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kH(2,d)
w=this.b.w
w.toString
d.mu(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.k+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.apU.prototype={
k(d){return y.k+B.k(this.w)+"}"}}
A.Hf.prototype={
ga2q(){var w=this.y
return w!=null?w.cy:this.ch},
sMW(d){var w
this.CW=d
w=d.b
if(w!=null)w.c=3
w=d.b
if(w!=null)w.b="MQIsdp"},
xx(d,e){return this.azc(d,e)},
azc(d,e){var w=0,v=B.L(x.F),u,t=this,s,r,q,p,o,n,m
var $async$xx=B.G(function(f,g){if(f===1)return B.I(g,v)
for(;;)switch(w){case 0:if(!t.d){s=new A.UD()
s.a="mqtt-client::ClientIncorrectInstantiationException: Incorrect instantiation, do notinstantiate MqttClient directly, use MqttServerClient or MqttBrowserClient"
throw B.f(s)}$.aZf=$.aZf+1
s=t.CW
if(s!=null)s.a1R(d,e)
r=t.y
if(r==null)throw B.f(B.aA("connectionHandler is null"))
s=t.z
if(s!=null)r.at=s
r.b=t.gaFh()
r.e=r.d=r.c=r.a=null
A.az("MqttClient::connect - Connection timeout period is 5000 milliseconds",!1)
s=t.k1
q=$.b5f()
p=x.S
o=x.c
s=new A.Xh(q,B.o(p,o),B.o(p,o),B.o(x.I,o),B.o(x.E,x.K),r,new B.er(null,null,x.U),s)
o=r.ch
o.h(0,C.je,s.gaDS())
o.h(0,C.jd,s.gaDQ())
o.h(0,C.jh,s.gaDU())
o.h(0,C.jg,s.gaDY())
o.h(0,C.jf,s.gaDW())
t.ay=s
s.r=!1
s=t.k1
n=x.Z
q=new A.Zm(q,B.o(p,n),B.o(p,n),B.o(p,n),r,s,new B.hy(null,null,x.M))
o.h(0,C.mZ,q.gaz8())
o.h(0,C.mV,q.gaza())
s.ra(x.b).e7(q.gaIu())
s.ra(x.k).e7(q.gatq())
t.Q=q
q.x=q.w=q.r=null
q.y=!0
s=t.at
if(s!==0){A.az("MqttClient::connect - keep alive is enabled with a value of "+s+" seconds",!1)
s=t.k1
q=t.at
p=new A.VM()
p.y=r
p.x=s
p.a=q*1000
o.h(0,C.jb,p.gaId())
o.h(0,C.jc,p.gaIg())
r.CW.push(p.gaGI())
p.c=B.cg(B.eb(0,p.a,0),p.ga6f())
A.az("MqttConnectionKeepAlive:: Initialised with a keep alive value of "+q+" seconds",!1)
A.az("MqttConnectionKeepAlive:: Disconnect on no ping response is disabled",!1)
t.as=p}else A.az("MqttClient::connect - keep alive is disabled",!1)
m=t.CW
if(m==null){s=A.aZe()
q=s.c
q===$&&B.a()
q.sDf(t.c)
q=s.b.d
q===$&&B.a()
q.d=C.aU
m=s.a1R(d,e)
s=m.b.d
s===$&&B.a()
s.b=!0
t.sMW(m)}s=m.c
s===$&&B.a()
if(s.e.length===0)s.sDf(t.c)
s=m.b
if(s!=null)s.e=t.at
t.sMW(m)
u=r.xy(t.a,t.b,m)
w=1
break
case 1:return B.J(u,v)}})
return B.K($async$xx,v)},
aIt(d,e,f,g){var w,v,u,t,s,r,q,p,o,n,m=null,l=this.y,k=l==null
if((k?m:l.cy.a)!==C.c0)throw B.f(A.aWQ(k?m:l.cy.a))
try{w=A.aSO(d)
l=this.ay
l.toString
k=w.a
A.az("PublishingManager::publish - entered with topic "+k,!1)
t=l.a.GU()
s=new A.v5()
r=new A.iD(C.aU)
r.a=C.jd
s.a=r
q=new A.VS(r,C.aO,new A.e0())
q.hM()
s.b=q
p=new A.VP(m,m)
o=new A.fJ(new Uint8Array(0),0)
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
l=new A.UO()
l.a="mqtt-client::InvalidTopicException: Topic "+d+" is "+J.bg(v)
B.fU(l,u)}else throw n}},
aBo(d){var w
A.az("MqttClient::_disconnectOnNoPingResponse - disconnecting, no ping request response for 0 seconds",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.Pn()}this.OH()},
aBm(d){var w
A.az("MqttClient::disconnectOnNoMessageSent - disconnecting, no message sent due to exception like socket exception",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.Pn()}this.OH()},
OH(){var w=this.y
if(w==null){A.az("MqttClient::internalDisconnect - not invoking disconnect, no connection handler",!1)
return}if(w.cx)this.IY(!0)},
IY(d){var w,v,u,t,s=this
if(!d){w=s.y
if(w!=null){A.az("MqttConnectionHandlerBase::disconnect - entered",!1)
if(w.cy.a===C.c0){v=new A.Hi()
u=new A.iD(C.aU)
u.a=C.mW
v.a=u
w.kI(v)}A.az(y.B,!1)
w.cy.a=C.cj}w=s.y
if(w!=null){v=w.ay
v===$&&B.a()
v.vB()
w.ay.Dg()}t=C.SQ}else t=C.SP
w=s.ay
if(w!=null)w.x.b1()
s.ay=null
w=s.Q
if(w!=null)w.Q.b1()
s.Q=null
w=s.as
if(w!=null){A.az("MqttConnectionKeepAlive::stop - stopping keep alive",!1)
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
A.zq.prototype={}
A.y5.prototype={}
A.qy.prototype={}
A.xx.prototype={}
A.At.prototype={}
A.yn.prototype={}
A.ym.prototype={}
A.aoU.prototype={
GU(){var w=++this.a
return w===32768?this.a=1:w}}
A.l4.prototype={
H(){return"MqttQos."+this.b}}
A.oj.prototype={}
A.Xg.prototype={}
A.Xh.prototype={
aDT(d){var w,v=x.z.a(d).b
v===$&&B.a()
w=v.w
A.az("PublishingManager::handlePublishAcknowledgement for message id "+B.k(w),!1)
v=this.b
if(v.G(w)){w.toString
this.Y8(v.i(0,w))
v.F(0,w)}return!0},
aDR(d){var w,v,u,t,s,r,q,p,o,n,m=this
x.c.a(d)
w=d
v=!0
try{u=A.aSO(w.b.r)
A.az("PublishingManager::handlePublish - publish received from broker with topic "+B.k(u),!1)
if(w.a.c===C.aU){q=m.y
if(q!=null)A.zw(q,new A.qy(d,u))}else if(w.a.c===C.bL){q=m.y
if(q!=null)A.zw(q,new A.qy(d,u))
t=w.b.w
p=new A.zx()
q=new A.iD(C.aU)
q.a=C.je
p.a=q
q=new A.VN(C.aO,new A.e0())
q.hM()
p.b=q
q.w=t
s=p
m.f.kI(s)}else if(w.a.c===C.eD){q=m.d
if(!q.G(w.b.w))q.h(0,w.b.w,w)
o=new A.zz()
q=new A.iD(C.aU)
q.a=C.jf
o.a=q
q=new A.VQ(C.aO,new A.e0())
q.hM()
o.b=q
q.w=w.b.w
r=o
m.f.kI(r)}}catch(n){if(x.L.b(B.a0(n)))v=!1
else throw n}return v},
aDZ(d){var w,v,u,t,s,r,q,p=x.G.a(d).b
p===$&&B.a()
w=p.w
A.az("PublishingManager::handlePublishRelease - for message identifier "+B.k(w),!1)
v=!0
try{u=this.d.F(0,w)
if(u!=null){t=A.aSO(u.b.r)
p=this.y
if(p!=null)A.zw(p,new A.qy(u,t))
r=new A.zy()
p=new A.iD(C.aU)
p.a=C.jh
r.a=p
p=new A.VO(C.aO,new A.e0())
p.hM()
r.b=p
p.w=u.b.w
s=r
this.f.kI(s)}}catch(q){if(x.L.b(B.a0(q)))v=!1
else throw q}return v},
aDV(d){var w,v=x.a.a(d).b
v===$&&B.a()
w=v.w
A.az("PublishingManager::handlePublishComplete - for message identifier "+B.k(w),!1)
this.Y8(this.b.F(0,w))
return!0},
aDX(d){var w,v,u
x.R.a(d)
w=d.b
w===$&&B.a()
v=w.w
A.az("PublishingManager::handlePublishReceived - for message identifier "+B.k(v),!1)
if(this.b.G(v)){u=new A.zA()
w=new A.iD(C.aU)
w.a=C.jg
u.a=w
w.c=C.bL
w=new A.VR(C.aO,new A.e0())
w.hM()
u.b=w
w.w=d.b.w
this.f.kI(u)}return!0},
Y8(d){var w=this.x
if(w.d!=null&&d!=null){A.az("PublishingManager::_notifyPublish - adding message to published stream for topic "+d.b.r,!1)
A.aZi(w,d)}}}
A.AZ.prototype={
gli(){return this.w},
grv(){var w=this.x
return w},
gya(){var w=this.e,v=B.Z(w).j("b4<1>")
w=B.V(new B.b4(w,new A.ayj(),v),v.j("A.E"))
return w},
gAe(){var w=this.e,v=B.Z(w).j("b4<1>")
w=B.V(new B.b4(w,new A.ayk(),v),v.j("A.E"))
return w},
gA(d){var w=D.c.gA(this.grv().a),v=B.fG(this.gli()),u=this.c?519018:218159
return w+v+u},
aKq(d){var w,v,u=this
if(d.length!==u.gya().length+u.gAe().length)return!1
for(w=0;w<u.gya().length+u.gAe().length;++w)u.e[w].sli(d[w])
v=D.b.ga2(u.e).gli()
if(!u.c)u.w=v
return!0},
l(d,e){var w,v=this
if(e==null)return!1
if(v!==e)w=e instanceof A.AZ&&B.q(v)===B.q(e)&&v.grv().a===e.grv().a&&v.gli()===e.gli()&&v.c===e.c&&v.b==e.b
else w=!0
return w},
k(d){var w=this,v="Subscription:: Batch: "+w.c+", MID: "+B.k(w.b)+", Topic: "+w.grv().a+", QoS: "+w.gli().k(0)+", Total Batch: "+(w.gya().length+w.gAe().length)+"\n"
return v.charCodeAt(0)==0?v:v}}
A.Zl.prototype={}
A.Zm.prototype={
aKl(d){var w,v,u
for(w=this.b,w=new B.bD(w,w.r,w.e,B.l(w).j("bD<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}for(w=this.c,w=new B.bD(w,w.r,w.e,B.l(w).j("bD<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}return null},
a2M(d,e){var w,v,u,t,s,r,q,p
try{w=A.aT7(d)
v=this.a.GU()
u=A.aT6()
u.x=w
r=u
if(!r.c)r.w=e
u.b=v
Date.now()
this.c.h(0,v,u)
r=A.aZj()
q=u.b
r.b.w=q
t=r.aK5(u.grv().a).axK(u.gli())
this.e.kI(t)
return u}catch(p){r=B.a0(p)
if(x.L.b(r)){s=r
A.az("SubscriptionsManager::createNewSubscription exception raised, text is "+B.k(s),!1)
return null}else throw p}},
aAE(d){var w,v,u,t,s,r,q,p,o,n,m,l
try{w=A.aT7(D.b.ga2(d).grv())
v=this.a.GU()
u=A.aT6()
u.c=!0
u.x=w
u.e=d
u.r=d
u.b=v
Date.now()
this.c.h(0,v,u)
q=A.aZj()
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
o=s.gli()
m=n.c
m===$&&B.a()
if(m.c.G(n.d))n.c.c.h(0,n.d,o)}this.e.kI(t)
return u}catch(l){o=B.a0(l)
if(x.L.b(o)){r=o
A.az("SubscriptionsManager::createNewBatchSubscription exception raised, text is "+B.k(r),!1)
return null}else throw l}},
aIv(d){A.aZi(this.Q,B.b([new A.oj(d.a,x.X)],x.f))},
az9(d){var w,v,u,t
x.A.a(d)
w=d.b.w
w.toString
A.aT6()
v=this.c
if(v.G(w))u=v.i(0,w)
else{A.az("SubscriptionsManager::confirmSubscription Sub Ack received for non pending subscription",!1)
return!1}if(!u.c){t=d.c
t===$&&B.a()
t=t.c
if(t.length===0||D.b.ga2(t)===C.n_){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription failed for single subscription "+D.b.ga2(d.c.c).k(0),!1)
return!1}}else{t=d.c
t===$&&B.a()
if(!u.aKq(t.c)){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription failed to update qos grants for batch subscription, lengths differ","Requested: 0, Received: "+d.c.c.length)
return!1}if(d.c.c.length===0||u.gya().length===u.gya().length+u.gAe().length){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription all qos grants failed",!1)
return!1}}v.F(0,w)
this.b.h(0,w,u)
return!0},
azb(d){var w,v=x.D.a(d).b
v===$&&B.a()
w=v.w
v=this.d
if(v.G(w)){v.i(0,w)
this.b.F(0,null)}A.az("SubscriptionsManager::confirmUnsubscribe subscription not found in pending unsubscriptions",!1)
return!0},
atr(d){var w,v,u,t,s,r,q,p=this
A.az("Subscriptionsmanager::_resubscribe - resubscribing from auto reconnect "+d.a,!1)
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
if(q.c)p.aAE(q.r)
else{t=q.x
p.a2M(t.a,q.gli())}}}}
A.oX.prototype={
gA(d){return D.c.gA(this.a)},
Tg(d,e){var w,v
this.b=B.b(this.a.split("/"[0]),x.s)
for(w=e.length,v=0;v<e.length;e.length===w||(0,B.y)(e),++v)e[v].$1(this)},
l(d,e){if(e==null)return!1
if(this===e)return!0
return e instanceof A.oX&&this.a===e.a},
k(d){return this.a}}
A.zu.prototype={
gE(d){return this.a.b},
aFJ(){if(this.a.b-this.b>0)return!0
return!1},
h7(){var w=this,v=w.a.i(0,w.b),u=w.b
if(u<=w.a.b-1)w.b=u+1
else return-1
return v},
a6z(){return(this.h7()<<8>>>0)+this.h7()},
nx(d){var w,v,u,t,s=this,r=null,q=s.a,p=q.b
if(p<d||s.b+d>p)throw B.f(B.ci("mqtt_client::ByteBuffer::read: The buffer does not have enough bytes for the read operation length "+s.gE(0)+", count "+d+", position "+s.b+", buffer "+q.k(q)))
if($.aZd){w=new A.fJ(new Uint8Array(0),0)
p=s.b
v=p+d
B.dE(p,v,q.gE(0),r,r)
w.O(0,B.hr(q,p,v,B.l(q).j("aU.E")))
s.b+=d
u=new A.fJ(new Uint8Array(0),0)
u.O(0,w)
return u}else{p=s.b+=d
v=new A.fJ(new Uint8Array(0),0)
t=p-d
B.dE(t,p,q.gE(0),r,r)
v.O(0,B.hr(q,t,p,B.l(q).j("aU.E")))
return v}},
aIT(d){var w,v,u,t=this,s=t.a,r=s.b
if(r<d||t.b+d>r)throw B.f(B.ci("mqtt_client::ByteBuffer::readPayload: The buffer does not have enough bytes for the read operation length "+t.gE(0)+", count "+d+", position "+t.b+", buffer "+s.k(s)))
if(d<=32767)return t.nx(d)
r=t.b
if(r!==0){s.G2(s,0,r)
s=t.b=0}else s=r
w=new A.fJ(new Uint8Array(0),0)
r=t.a
v=r.b
if(v===d){t.b=v
s=new A.fJ(new Uint8Array(0),0)
s.O(0,r)
return s}else{s+=d
B.dE(s,v,r.gE(0),null,null)
w.O(0,B.hr(r,s,v,B.l(r).j("aU.E")).en(0))
r=t.a
r.G2(r,t.b+d,r.b)
u=new A.fJ(new Uint8Array(0),0)
u.O(0,t.a)
t.a.sE(0,0)
t.a.O(0,w)
t.b=0
return u}},
nG(d){var w=this.a,v=w.b,u=this.b
if(v===u)w.ou(d)
else w.h(0,u,d);++this.b},
mu(d){this.nG(D.d.aI(d,8))
this.nG(d&255)},
jG(d){this.a.O(0,d)
this.b=this.a.b},
aKN(d){A.qC(this,d)},
k(d){var w,v=this.a
v=v.ga6(v)
if(!v){v=this.a
w=B.mn(v.en(v),"[","]")}else w="null or empty"
return w}}
A.apK.prototype={
gE(d){return this.a.b},
axm(d){var w,v,u,t,s,r
for(w=new B.fR(d),v=x.V,w=new B.bR(w,w.gE(0),v.j("bR<aU.E>")),u=x.t,v=v.j("aU.E");w.v();){t=w.d
if(t==null)t=v.a(t)
if(t<=255&&t>=0)this.a.ou(t)
else{s=new Uint16Array(B.b2(B.b([t],u)))
t=this.a
r=J.b7v(D.n1.gbe(s))
t.a06(r,0,null)}}return this}}
A.VG.prototype={
avA(){this.d=!1
var w=this.b
w===$&&B.a()
w.ew()}}
A.Rx.prototype={}
A.Wd.prototype={}
A.Eg.prototype={}
A.Bf.prototype={
gE(d){return this.b},
i(d,e){if(e>=this.b)throw B.f(B.UE(e,this,null,null,null))
return this.a[e]},
h(d,e,f){var w
if(e>=this.b)throw B.f(B.UE(e,this,null,null,null))
w=this.a
w.$flags&2&&B.a4(w)
w[e]=f},
sE(d,e){var w,v,u,t,s=this,r=s.b
if(e<r)for(w=s.a,v=w.$flags|0,u=e;u<r;++u){v&2&&B.a4(w)
w[u]=0}else{r=s.a.length
if(e>r){if(r===0)t=new Uint8Array(e)
else t=s.Lx(e)
D.l.bR(t,0,s.b,s.a)
s.a=t}}s.b=e},
ou(d){var w,v=this,u=v.b
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
tF(d,e,f,g){B.fb(f,"start")
this.a06(e,f,g)},
O(d,e){return this.tF(0,e,0,null)},
a06(d,e,f){var w,v,u
if(x.j.b(d))f=J.aT(d)
if(f!=null){this.avM(this.b,d,e,f)
return}for(w=J.bx(d),v=0;w.v();){u=w.gN()
if(v>=e)this.ou(u);++v}if(v<e)throw B.f(B.aA("Too few elements"))},
avM(d,e,f,g){var w,v,u,t,s=this
if(x.j.b(e)){w=J.aa(e)
if(f>w.gE(e)||g>w.gE(e))throw B.f(B.aA("Too few elements"))}v=g-f
u=s.b+v
s.avL(u)
w=s.a
t=d+v
D.l.bD(w,t,s.b+v,w,d)
D.l.bD(s.a,d,t,e,f)
s.b=u},
avL(d){var w,v=this
if(d<=v.a.length)return
w=v.Lx(d)
D.l.bR(w,0,v.b,v.a)
v.a=w},
Lx(d){var w=this.a.length*2
if(d!=null&&w<d)w=d
else if(w<8)w=8
return new Uint8Array(w)},
a07(d){var w=this.Lx(null)
D.l.bR(w,0,d,this.a)
this.a=w},
bD(d,e,f,g,h){var w=this.b
if(f>w)throw B.f(B.co(f,0,w,null,null))
w=this.a
if(g instanceof A.fJ)D.l.bD(w,e,f,g.a,h)
else D.l.bD(w,e,f,g,h)},
bR(d,e,f,g){return this.bD(0,e,f,g,0)}}
A.a3l.prototype={}
A.fJ.prototype={}
var z=a.updateTypes(["D(dD?)","~(oX)","~()","~(h?,l4?)","D(aWk)","~(H<oj<dD>>)","~(xx)","~(zq)","~(y5)","D()","~(yn)","~(ym)","~(qy)","~(At)","~(h)"])
A.ahi.prototype={
$1(d){return this.a.b(d)},
$S:561}
A.apN.prototype={
$0(){var w=this.a
w.f=!1
if(!w.d)w.aH()},
$S:0}
A.apO.prototype={
$1(d){var w,v=x.c.a(J.c3(d,0).b),u=v.c
u===$&&B.a()
u=u.c
u===$&&B.a()
w=A.bbK(u)
this.a.Br(w,this.b)},
$S:z+5}
A.apD.prototype={
$1(d){return d},
$S:48}
A.apE.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
this.b.a_x()
return this.c.ew()},
$S:2}
A.apF.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apG.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket has erred",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apz.prototype={
$1(d){return d},
$S:48}
A.apA.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
this.b.a_x()
return this.c.ew()},
$S:2}
A.apB.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apC.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket has errored",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eQ(new A.k7(C.cj,C.cD,C.eC))},
$S:2}
A.apH.prototype={
$1(d){A.az("MqttBrowserConnection::_startListening - websocket is closed",!1)
this.a.Pn()},
$S:2}
A.apI.prototype={
$1(d){this.a.pi(d.data)},
$S:2}
A.apJ.prototype={
$1(d){var w
A.az("MqttBrowserConnection::_startListening - websocket has errored",!1)
w=this.a
w.vB()
w.Dg()
w.a=null
if(w.e!=null){A.az("MqttConnectionBase::_onError - calling disconnected callback",!1)
w.e.$0()}},
$S:2}
A.apT.prototype={
$2(d,e){var w=this.a
d.toString
A.qC(w,d)
w.nG(e.a)},
$S:z+3}
A.apR.prototype={
$2(d,e){var w,v=this.a,u=v.a
d.toString
w=u+this.b.lq(d).b
v.a=w
v.a=w+1},
$S:z+3}
A.apS.prototype={
$2(d,e){var w=this.a,v="{{ Topic={"+B.k(d)+"}, Qos={"+B.k(e)+"} }}\n"
w.a+=v},
$S:z+3}
A.ayj.prototype={
$1(d){d.gli()
return!1},
$S:z+4}
A.ayk.prototype={
$1(d){d.gli()
return!0},
$S:z+4}
A.ayi.prototype={
$1(d){return(D.c.p(d,"#")||D.c.p(d,"+"))&&d.length>1},
$S:28};(function aliases(){var w=A.dD.prototype
w.SF=w.is
w.iD=w.k
w=A.Hf.prototype
w.ab9=w.xx})();(function installTearOffs(){var w=a._instance_0u,v=a._static_1,u=a._instance_1u
w(A.jm.prototype,"gcX","m",2)
v(A,"blc","bcU",1)
v(A,"ble","bec",1)
v(A,"bld","beb",1)
v(A,"b3K","beQ",1)
v(A,"b3L","beR",1)
var t
u(t=A.VL.prototype,"gaxX","D2",6)
u(t,"gaGG","aGH",7)
u(t,"gazf","azg",8)
w(t=A.VM.prototype,"ga6f","aIf",9)
u(t,"gaId","aIe",0)
u(t,"gaIg","aIh",0)
u(t,"gaGI","aGJ",0)
w(t,"ga5Q","aH_",2)
u(t=A.Hf.prototype,"gaBn","aBo",10)
u(t,"gaBl","aBm",11)
w(t,"gaFh","OH",2)
u(t=A.Xh.prototype,"gaDS","aDT",0)
u(t,"gaDQ","aDR",0)
u(t,"gaDY","aDZ",0)
u(t,"gaDU","aDV",0)
u(t,"gaDW","aDX",0)
u(t=A.Zm.prototype,"gaIu","aIv",12)
u(t,"gaz8","az9",0)
u(t,"gaza","azb",0)
u(t,"gatq","atr",13)
u(A.zu.prototype,"gaKM","aKN",14)
w(A.VG.prototype,"gavz","avA",2)})();(function inheritance(){var w=a.mixin,v=a.inheritMany,u=a.inherit
v(B.t,[A.ahh,A.a48,A.VK,A.VL,A.Hf,A.VM,A.e0,A.RY,A.Sh,A.UD,A.UM,A.UN,A.UO,A.W7,A.VH,A.dD,A.apM,A.apY,A.iD,A.k7,A.zq,A.y5,A.qy,A.xx,A.At,A.yn,A.ym,A.aoU,A.Eg,A.oX,A.Xh,A.Wd,A.Zm,A.zu,A.apK,A.VG,A.Rx])
v(B.dZ,[A.ahi,A.apO,A.apD,A.apE,A.apF,A.apG,A.apz,A.apA,A.apB,A.apC,A.apH,A.apI,A.apJ,A.ayj,A.ayk,A.ayi])
u(A.jm,A.a48)
u(A.apN,B.fz)
u(A.VF,A.VK)
u(A.apx,A.VL)
u(A.apy,A.VF)
u(A.ayn,A.apx)
u(A.apw,A.Hf)
v(B.iU,[A.Hj,A.zv,A.mB,A.fm,A.l4])
v(A.dD,[A.Hh,A.Hg,A.Hi,A.Hk,A.Hl,A.v5,A.zx,A.zy,A.zz,A.zA,A.Hn,A.Hm,A.VV,A.Ho])
v(A.apM,[A.VI,A.VP,A.VT,A.apP,A.apV])
v(A.apY,[A.VJ,A.apL,A.VS,A.VN,A.VO,A.VQ,A.VR,A.VU,A.apQ,A.apW,A.apU])
v(B.fQ,[A.apT,A.apR,A.apS])
u(A.oj,A.Eg)
v(A.oX,[A.Xg,A.Zl])
u(A.AZ,A.Wd)
u(A.Bf,B.aU)
u(A.a3l,A.Bf)
u(A.fJ,A.a3l)
w(A.a48,B.aM)})()
B.fN(b.typeUniverse,JSON.parse('{"jm":{"aM":[],"a9":[]},"v5":{"dD":[]},"AZ":{"Wd":["Eg"]},"RY":{"bj":[]},"Sh":{"bj":[]},"UD":{"bj":[]},"UM":{"bj":[]},"UN":{"bj":[]},"UO":{"bj":[]},"W7":{"bj":[]},"Hh":{"dD":[]},"Hg":{"dD":[]},"Hi":{"dD":[]},"Hk":{"dD":[]},"Hl":{"dD":[]},"zx":{"dD":[]},"zy":{"dD":[]},"zz":{"dD":[]},"zA":{"dD":[]},"Hn":{"dD":[]},"Hm":{"dD":[]},"VV":{"dD":[]},"Ho":{"dD":[]},"Xg":{"oX":[]},"Zl":{"oX":[]},"Bf":{"aU":["1"],"H":["1"],"aK":["1"],"A":["1"]},"a3l":{"Bf":["m"],"aU":["m"],"H":["m"],"aK":["m"],"A":["m"]},"fJ":{"Bf":["m"],"aU":["m"],"H":["m"],"aK":["m"],"A":["m"],"aU.E":"m","A.E":"m"}}'))
B.lD(b.typeUniverse,JSON.parse('{"VF":1,"VK":1}'))
var y={t:"Connect Variable Header: SessionPresent={",a:"Guarded fire - event bus is closed - event not fired",h:"MqttConnectPayload - client identifier is : ",B:"MqttConnectionHandlerBase::_performConnectionDisconnect entered",p:"PublishAck Variable Header: MessageIdentifier={",w:"PublishComplete Variable Header: MessageIdentifier={",g:"PublishReceived Variable Header: MessageIdentifier={",i:"PublishRelease Variable Header: MessageIdentifier={",k:"UnsubscribeAck Variable Header: MessageIdentifier={"}
var x=(function rtii(){var w=B.T
return{h:w("xx"),Q:w("Rx<Eg>"),V:w("fR"),_:w("y5"),o:w("ym"),u:w("yn"),C:w("cu"),L:w("bj"),y:w("n<aWk>"),r:w("n<oa>"),v:w("n<l4>"),f:w("n<oj<dD>>"),p:w("n<bo8>"),d:w("n<hM<@>>"),s:w("n<h>"),t:w("n<m>"),B:w("n<D(dD?)>"),x:w("n<~(oX)>"),m:w("bd"),j:w("H<@>"),W:w("zq"),b:w("qy"),e:w("k7"),N:w("Hg"),q:w("fm"),z:w("zx"),a:w("zy"),c:w("v5"),R:w("zz"),G:w("zA"),X:w("oj<dD>"),A:w("Hm"),D:w("Ho"),K:w("t"),k:w("At"),P:w("c2<H<oj<dD>>>"),Z:w("AZ"),E:w("hu"),U:w("er<v5>"),J:w("er<@>"),l:w("b1<k7?>"),Y:w("b1<~>"),w:w("ab<k7?>"),g:w("ab<~>"),M:w("hy<H<oj<dD>>>"),S:w("m"),F:w("k7?"),n:w("l4?"),T:w("h?"),i:w("D(dD?)?"),I:w("m?"),H:w("~")}})();(function constants(){var w=a.makeConstList
C.yo=new A.mB(0,"connectionAccepted")
C.yp=new A.mB(1,"unacceptedProtocolVersion")
C.yq=new A.mB(2,"identifierRejected")
C.aO=new A.mB(3,"brokerUnavailable")
C.yr=new A.mB(4,"badUsernameOrPassword")
C.ys=new A.mB(5,"notAuthorized")
C.cD=new A.mB(6,"noneSpecified")
C.Ol=w([C.yo,C.yp,C.yq,C.aO,C.yr,C.ys,C.cD],B.T("n<mB>"))
C.SR=new A.fm(0,"reserved1")
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
C.SS=new A.fm(15,"reserved2")
C.OW=w([C.SR,C.mU,C.mX,C.jd,C.je,C.jf,C.jg,C.jh,C.mY,C.mZ,C.yu,C.mV,C.jb,C.jc,C.mW,C.SS],B.T("n<fm>"))
C.Pz=w(["mqtt","mqttv3.1","mqttv3.11"],x.s)
C.Qh=w(["mqtt"],x.s)
C.cj=new A.zv(1,"disconnected")
C.yt=new A.zv(2,"connecting")
C.c0=new A.zv(3,"connected")
C.SO=new A.zv(4,"faulted")
C.SP=new A.Hj(0,"unsolicited")
C.SQ=new A.Hj(1,"solicited")
C.eC=new A.Hj(2,"none")
C.aU=new A.l4(0,"atMostOnce")
C.bL=new A.l4(1,"atLeastOnce")
C.eD=new A.l4(2,"exactlyOnce")
C.ST=new A.l4(3,"reserved1")
C.n_=new A.l4(4,"failure")
C.a5b=B.aI("@")})();(function staticFields(){$.aZd=!1
$.aZf=0})();(function lazyInitializers(){var w=a.lazyFinal
w($,"bo2","b5f",()=>new A.aoU())})()};
(a=>{a["omNWv83ePg9V5mDJeCrD7iFPPUk="]=a.current})($__dart_deferred_initializers__);