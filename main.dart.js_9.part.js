((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,E,A={agi:function agi(d){this.a=d},agj:function agj(d){this.a=d},
aX9(){var w=B.b([],x.r),v=$.cD,u=(v==null?$.cD=$.fJ():v).fu("[DEFAULT]")
B.cN(u,$.fe(),!0)
v=B.yi(new B.eh(u))
v=new B.ahb(v)
return new A.j8(v,w,$.aw())},
j8:function j8(d,e,f){var _=this
_.a=d
_.c=_.b=null
_.d=!1
_.e=e
_.r=_.f=!1
_.K$=0
_.U$=f
_.af$=_.ag$=0},
aoF:function aoF(d,e){this.a=d
this.b=e},
aoG:function aoG(d,e){this.a=d
this.b=e},
a3p:function a3p(){},
UY:function UY(){},
aop:function aop(){},
aoq:function aoq(d,e,f){var _=this
_.as=d
_.a=null
_.b=e
_.d=$
_.e=null
_.f=f},
aov:function aov(){},
aow:function aow(d,e,f){this.a=d
this.b=e
this.c=f},
aox:function aox(d,e){this.a=d
this.b=e},
aoy:function aoy(d,e){this.a=d
this.b=e},
aor:function aor(){},
aos:function aos(d,e,f){this.a=d
this.b=e
this.c=f},
aot:function aot(d,e){this.a=d
this.b=e},
aou:function aou(d,e){this.a=d
this.b=e},
aoz:function aoz(d){this.a=d},
aoA:function aoA(d){this.a=d},
aoB:function aoB(d){this.a=d},
axe:function axe(d,e,f,g,h){var _=this
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
aoo:function aoo(d,e,f){var _=this
_.a=d
_.b=1883
_.c=e
_.d=!1
_.as=_.Q=_.z=_.y=null
_.at=0
_.ay=null
_.ch=f
_.k1=_.cx=_.CW=null},
b9l(d){var w,v
for(w=d.length,v=0;v<w;++v)if(d.charCodeAt(v)>127)throw B.f(B.c3("mqtt_client::MQTTEncoding: The input string has extended UTF characters, which are not supported"))},
aUM(d){var w=new A.Rz()
w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation."
if(d!=null)w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation. Current state is "+d.H().split(".")[1]
return w},
ak4(d){var w=new A.U5()
w.a="mqtt-client::InvalidHeaderException: "+d
return w},
aWn(d){var w=new A.U6()
w.a="mqtt-client::InvalidMessageException: "+d
return w},
uM(d){var w=new A.Vq()
w.a="mqtt-client::NoConnectionException: "+d
return w},
z9(d,e){var w=d.a
if((w.c&4)===0)w.t(0,e)
else A.az(y.a,!1)},
aXb(d,e){if((d.c&4)!==0){A.az("Guarded add - stream is closed - event not added",!1)
return}if(d.d==null)A.az("Guarded add - stream has no listeners - adding anyway",!1)
d.t(0,e)},
aX7(){var w=new A.GI(),v=new A.it(C.aQ)
v.a=C.mM
w.a=v
v=A.aQw()
w.b=v
A.aQw()
w.c=new A.V0(v)
return w},
aQw(){var w=new A.V1(C.aM,new A.dR())
w.hF()
return w},
b9n(d){var w,v=new A.fD(new Uint8Array(0),0),u=0
do{w=d.fZ()
v.ol(w);++u}while(u<=4&&(w&128)===128)
return v},
b9m(d){var w,v,u,t,s
for(w=B.k(d),v=new B.bN(d,d.gE(0),w.j("bN<aP.E>")),w=w.j("aP.E"),u=0,t=1;v.v();){s=v.d
u+=((s==null?w.a(s):s)&127)*t
t*=128}return u},
b9p(d){var w,v,u,t,s,r
try{w=new A.it(C.aQ)
t=new A.it(C.aQ)
t.it(d)
w=t
if(d.a.b-d.b<w.e){d.b=0
s=A.aWn("Available bytes is less than the message size")
throw B.f(s)}s=A.b9o(w,d)
return s}catch(r){s=B.a_(r)
if(x.L.b(s)){v=s
u=B.ag(r)
B.fN(A.aWn("The data provided in the message stream was not a valid MQTT Message, exception is "+B.l(v)),u)}else throw r}},
b9o(d,e){var w,v,u,t
switch(d.a){case C.mM:w=new A.GI()
w.a=d
v=new A.V1(C.aM,new A.dR())
v.it(e)
w.b=v
A.aQw()
u=new A.V0(v)
u.sCD(A.z7(e))
t=v.d
t===$&&B.a()
if(t.c){u.b=A.z7(e)
u.c=A.z7(e)}if(v.d.r){t=D.c.fG(A.z7(e))
u.d=t}if(v.d.f){v=D.c.fG(A.z7(e))
u.f=v}w.c=u
break
case C.mP:w=new A.GH()
w.a=d
w.RS(e)
v=new A.aoD(C.aM,new A.dR())
v.it(e)
w.b=v
break
case C.j2:w=new A.uH()
w.a=d
w.RS(e)
v=new A.Va(w.a,C.aM,new A.dR())
v.hF()
v.it(e)
w.b=v
u=w.a
t=new A.V7(u,v)
t.c=e.aHv(u.e-v.a)
w.c=t
break
case C.j3:w=new A.za()
w.a=d
v=new A.V5(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
break
case C.j6:w=new A.zb()
w.a=d
v=new A.V6(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
break
case C.j4:w=new A.zc()
w.a=d
v=new A.V8(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
break
case C.j5:w=new A.zd()
w.a=d
v=new A.V9(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
break
case C.mQ:w=new A.GO()
w.a=d
d.c=C.bF
v=new A.Vc(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
v=new A.Vb(v,d,B.o(x.T,x.n))
v.it(e)
w.c=v
break
case C.mR:w=new A.GN()
w.a=d
v=new A.aoI(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
v=new A.aoH(v,d,B.b([],x.v))
v.it(e)
w.c=v
break
case C.yb:w=new A.Vd()
w.a=d
v=new A.aoO(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
v=new A.aoN(v,d,B.b([],x.s))
v.it(e)
w.c=v
break
case C.mN:w=new A.GP()
w.a=d
v=new A.aoM(C.aM,new A.dR())
v.hF()
v.nr(e)
w.b=v
break
case C.j0:w=new A.GL()
w.a=d
break
case C.j1:w=new A.GM()
w.a=d
break
case C.mO:w=new A.GJ()
w.a=d
break
default:throw B.f(A.ak4("The Message Type specified ("+d.k(0)+".messageType) is not a valid MQTT Message type or currently not supported."))}return w},
aXa(d){var w,v,u,t
for(w=B.k(d),v=new B.bN(d,d.gE(0),w.j("bN<aP.E>")),w=w.j("aP.E"),u="";v.v();u=t){t=v.d
if(t==null)t=w.a(t)
t=u+"<"+B.l(t)+">"}return u.charCodeAt(0)==0?u:u},
b9q(d){var w,v
try{w=D.al.fc(d.dS(d))
return w}catch(v){return""}},
aXc(){var w=new A.GO(),v=new A.it(C.aQ)
v.a=C.mQ
w.a=v
v.c=C.bF
v=new A.Vc(C.aM,new A.dR())
v.hF()
w.b=v
w.c=new A.Vb(null,null,B.o(x.T,x.n))
return w},
aQV(d){var w=new A.Wy(d)
w.St(d,B.b([A.b1B(),A.b1A(),A.biO()],x.x))
return w},
baC(d){var w=d.a
if(D.c.q(w,"#")||D.c.q(w,"+"))throw B.f(B.c3("mqtt_client::PublicationTopic: Cannot publish to a topic that contains MQTT topic wildcards (# or +)"))},
aRc(){var w=x.y
return new A.Ay(B.b([],w),B.b([],x.p),B.b([],w),C.mS,A.aRd("rawtopic"),new A.QQ(x.Q))},
aRd(d){var w=new A.YE(d)
w.St(d,B.b([A.b1B(),A.b1A(),A.biQ(),A.biP()],x.x))
return w},
bbT(d){var w=d.a
if(D.c.q(w,"#")&&!D.c.oQ(w,"#"))throw B.f(B.c3("mqtt_client::SubscriptionTopic: The rawTopic wildcard # can only be present at the end of a topic"))
if(w.length>1&&D.c.oQ(w,"#")&&!D.c.oQ(w,"/#"))throw B.f(B.c3("mqtt_client::SubscriptionTopic: Topics using the # wildcard longer than 1 character must be immediately preceeded by a the rawTopic separator /"))},
bbS(d){var w=d.b
w===$&&B.a()
if(D.b.hf(w,new A.ax9()))throw B.f(B.c3("mqtt_client::SubscriptionTopic: rawTopic Fragment contains a wildcard but is more than one character long"))},
bcv(d){var w=d.a.length
if(w>65535)throw B.f(B.c3("mqtt_client::Topic: The length of the supplied rawTopic ("+w+") is longer than the maximum allowable (65535)"))},
bcw(d){if(d.a.length===0)throw B.f(B.c3("mqtt_client::Topic: rawTopic must contain at least one character"))},
qd(d,e){d.jJ(new A.dR().lr(e))},
z7(d){var w,v=d.jF(2)
if(v.b<2)B.S(B.c3(y.z))
w=d.jF((v.ga4(v)<<8>>>0)+v.i(0,1))
return D.dP.bF(w.dS(w))},
az(d,e){},
aoP(d){switch(d){case 0:return C.aQ
case 1:return C.bF
case 2:return C.ey
case 128:return C.mS
default:return C.RN}},
GK:function GK(d,e){this.a=d
this.b=e},
z8:function z8(d,e){this.a=d
this.b=e},
V2:function V2(){},
V3:function V3(){},
V4:function V4(){var _=this
_.a=$
_.b=0
_.f=_.e=_.d=_.c=null
_.w=_.r=0
_.x=null
_.y=$
_.z=!1
_.as=_.Q=0},
dR:function dR(){},
Rf:function Rf(){this.a=$},
Rz:function Rz(){this.a=$},
TY:function TY(){this.a=$},
U5:function U5(){this.a=$},
U6:function U6(){this.a=$},
U7:function U7(){this.a=$},
Vq:function Vq(){this.a=$},
V_:function V_(d){var _=this
_.c=_.b=_.a=!1
_.d=d
_.r=_.f=_.e=!1},
GI:function GI(){this.b=null
this.c=$
this.a=null},
V0:function V0(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.e=""
_.f=null},
mg:function mg(d,e){this.a=d
this.b=e},
V1:function V1(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GH:function GH(){this.b=$
this.a=null},
aoD:function aoD(d,e){var _=this
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
GJ:function GJ(){this.a=null},
it:function it(d){var _=this
_.a=null
_.b=!1
_.c=d
_.d=!1
_.e=0},
dz:function dz(){},
fi:function fi(d,e){this.a=d
this.b=e},
aoE:function aoE(){},
aoQ:function aoQ(){},
GL:function GL(){this.a=null},
GM:function GM(){this.a=null},
uH:function uH(){this.b=null
this.c=$
this.a=null},
V7:function V7(d,e){this.a=d
this.b=e
this.c=$},
Va:function Va(d,e,f){var _=this
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
za:function za(){this.b=$
this.a=null},
V5:function V5(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zb:function zb(){this.b=$
this.a=null},
V6:function V6(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zc:function zc(){this.b=$
this.a=null},
V8:function V8(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zd:function zd(){this.b=$
this.a=null},
V9:function V9(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GO:function GO(){var _=this
_.b=null
_.c=$
_.a=_.d=null},
Vb:function Vb(d,e,f){this.a=d
this.b=e
this.c=f},
aoL:function aoL(d){this.a=d},
aoJ:function aoJ(d,e){this.a=d
this.b=e},
aoK:function aoK(d){this.a=d},
Vc:function Vc(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GN:function GN(){this.b=null
this.c=$
this.a=null},
aoH:function aoH(d,e,f){this.a=d
this.b=e
this.c=f},
aoI:function aoI(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Vd:function Vd(){this.b=null
this.c=$
this.a=null},
aoN:function aoN(d,e,f){this.a=d
this.b=e
this.c=f},
aoO:function aoO(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GP:function GP(){this.b=$
this.a=null},
aoM:function aoM(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GG:function GG(){},
jV:function jV(d,e,f){this.a=d
this.b=e
this.c=f},
z2:function z2(d){this.a=d},
xJ:function xJ(d){this.a=d},
qa:function qa(d,e){this.a=d
this.b=e},
x8:function x8(){},
A2:function A2(d){this.a=d},
y_:function y_(){},
xZ:function xZ(){},
anM:function anM(){this.a=0},
kL:function kL(d,e){this.a=d
this.b=e},
nZ:function nZ(d,e){this.b=d
this.$ti=e},
Wy:function Wy(d){this.a=d
this.b=$},
Wz:function Wz(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=!1
_.x=j
_.y=k},
Ay:function Ay(d,e,f,g,h,i){var _=this
_.b=null
_.c=!1
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i},
axa:function axa(){},
axb:function axb(){},
YE:function YE(d){this.a=d
this.b=$},
ax9:function ax9(){},
YF:function YF(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.x=_.w=_.r=null
_.y=!0
_.z=i
_.Q=j},
oB:function oB(){},
z6:function z6(d){this.a=d
this.b=0},
aoC:function aoC(){this.a=null},
UZ:function UZ(d){var _=this
_.a=d
_.c=_.b=$
_.d=!1},
QQ:function QQ(d){this.$ti=d},
Vw:function Vw(){},
DP:function DP(){},
AP:function AP(){},
a2C:function a2C(){},
fD:function fD(d,e){this.a=d
this.b=e}},C
J=c[1]
B=c[0]
D=c[2]
E=c[13]
A=a.updateHolder(c[7],A)
C=c[22]
A.agi.prototype={
qT(d){var w,v=this.a,u=B.k(v)
if(B.cq(d)===C.a3U)return d.j("c7<0>").a(new B.cp(v,u.j("cp<1>")))
else{u=u.j("cp<1>")
w=u.j("OE<c7.T>")
return new B.DO(new B.OE(new A.agj(d),new B.cp(v,u),w),w.j("@<c7.T>").aF(d).j("DO<1,2>"))}}}
A.j8.prototype={
gEn(){return this.f},
gaEh(){return this.r},
Ee(d){return this.aDz(d)},
aDz(a0){var w=0,v=B.K(x.H),u,t=2,s=[],r=[],q=this,p,o,n,m,l,k,j,i,h,g,f,e,d
var $async$Ee=B.E(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:if(q.f||q.r){w=1
break}q.r=!0
D.b.M(q.e)
if(!q.d)q.aI()
l="flutter_"+a0+"_"+Date.now()
k="inbody/users/"+a0
p=k+"/data"
o=k+"/status"
k=q.b
if(k==null){j=new A.aoo("wss://broker.emqx.io/mqtt",l,new A.jV(C.cd,C.cy,C.ex))
j.b=8084
j.z=C.Pc
q.b=j
k=j}k.at=20
i=A.aX7()
k=i.c
k===$&&B.a()
k.sCD(l)
k=i.b.d
k===$&&B.a()
k.b=!0
k.c=!0
h=i.c
h.b=o
h.c="offline"
k.d=C.bF
k.e=!0
q.b.sMi(i)
k=q.b
k.cx=new A.aoF(q,a0)
t=4
w=7
return B.L(k.CJ(),$async$Ee)
case 7:q.f=!0
k=q.b
h=p
if(k.ga1j().a!==C.bY){g=k.y
B.S(A.aUM(g==null?null:g.cy.a))}k=k.Q
if(k.aIU(h)==null)k.a1F(h,C.bF)
B.l(p)
f=new A.aoC()
f.a=new A.fD(new Uint8Array(0),0)
n=f
n.avW("online")
k=q.b
k.toString
k.aH5(o,C.bF,n.a,!0)
k=q.c
if(k!=null)k.aD()
k=q.b.Q
if(k==null)k=null
else{k=k.Q
k=x.P.a(new B.cp(k,B.k(k).j("cp<1>")))}q.c=k.e3(new A.aoG(q,a0))
r.push(6)
w=5
break
case 4:t=3
d=s.pop()
m=B.a_(d)
q.f=!1
r.push(6)
w=5
break
case 3:r=[2]
case 5:t=2
q.r=!1
if(!q.d)q.aI()
w=r.pop()
break
case 6:case 1:return B.I(u,v)
case 2:return B.H(s.at(-1),v)}})
return B.J($async$Ee,v)},
AS(d,e){return this.alx(d,e)},
alx(d,e){var w=0,v=B.K(x.H),u=1,t=[],s=this,r,q,p,o,n
var $async$AS=B.E(function(f,g){if(f===1){t.push(g)
w=u}for(;;)switch(w){case 0:u=3
r=D.e2.a1L(d,null)
q=E.aWj("mqtt_"+Date.now(),r)
D.b.e0(s.e,0,q)
if(!s.d)s.aI()
w=6
return B.L(s.a.Cc(e,q),$async$AS)
case 6:u=1
w=5
break
case 3:u=2
n=t.pop()
p=B.a_(n)
w=5
break
case 2:w=1
break
case 5:return B.I(null,v)
case 1:return B.H(t.at(-1),v)}})
return B.J($async$AS,v)},
azR(){var w=this,v=w.c
if(v!=null)v.aD()
w.c=null
v=w.b
if(v!=null)v.Il(!1)
w.f=!1
if(!w.d)w.aI()},
m(){var w,v=this
v.d=!0
w=v.c
if(w!=null)w.aD()
w=v.b
if(w!=null)w.Il(!1)
v.dC()},
$iab:1}
A.a3p.prototype={}
A.UY.prototype={
p8(d){var w,v,u,t,s,r,q,p,o,n=this,m=y.a
A.az("MqttBrowserConnection::_onData",!1)
u=J.dr(d,0,null)
if(u.length===0){A.az("MqttBrowserConnection::_ondata - Error - 0 byte message",!1)
return}t=n.d
t===$&&B.a()
t.a.N(0,u)
for(t=x.L,s=n.f;r=n.d,r.aEj();){w=!0
v=null
try{v=A.b9p(r)}catch(q){if(t.b(B.a_(q))){A.az("MqttBrowserConnection::_ondata - message is not yet valid, waiting for more data ...",!1)
w=!1}else throw q}if(!w){n.d.b=0
return}if(w){r=n.d
p=r.b
o=r.a
if(p<o.b){B.dA(0,p,o.gE(0),null,null)
if(p>0)o.HM(o,0,p)}else o.sE(0,0)
r.b=0
A.az("MqttBrowserConnection::_onData - message received ",v)
if(v.a.a===C.mP){r=v
p=s.a
if((p.c&4)===0){if(!p.gmF())B.S(p.my())
p.lJ(new A.xJ(r))}else A.az(m,!1)}else{r=v
p=s.a
if((p.c&4)===0){if(!p.gmF())B.S(p.my())
p.lJ(new A.z2(r))}else A.az(m,!1)}A.az("MqttBrowserConnection::_onData - message available event fired",!1)}else A.az("MqttBrowserConnection::_onData - WARN - message available event not fired, event bus is closed",!1)}},
Zn(){var w,v,u
this.vq()
A.az("MqttBrowserConnection::_startListening",!1)
try{this.aG5()}catch(v){u=B.a_(v)
if(x.L.b(u)){w=u
A.az("MqttBrowserConnection::_startListening - exception raised "+B.l(w),!1)}else throw v}}}
A.aop.prototype={}
A.aoq.prototype={
x9(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b0(new B.ad($.aj,x.w),x.l)
A.az("MqttBrowserWsConnection::connect - entered",!1)
w=null
try{w=B.oH(d)}catch(p){if(x.L.b(B.a_(p))){v=B.ag(p)
u="MqttBrowserWsConnection::connect - The URI supplied for the WS connection is not valid - "+d
B.fN(A.uM(u),v)}else throw p}if(w.glv()!=="ws"&&w.glv()!=="wss")throw B.f(A.uM("MqttBrowserWsConnection::connect - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.Pp(e)
t=w.gq0()
A.az("MqttBrowserWsConnection::connect -  WS URL is "+B.l(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a0<1,i>")
m=B.T(new B.a0(m,new A.aov(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.z6(new A.fD(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kg(s,"open",new A.aow(o,k,j),!1,n)
o.b=B.kg(s,"close",new A.aox(o,j),!1,n)
o.a=B.kg(s,"error",new A.aoy(o,j),!1,n)}catch(p){if(x.L.b(B.a_(p))){r=B.ag(p)
q="MqttBrowserWsConnection::connect - The connection to the message broker {"+B.l(t)+"} could not be made."
B.fN(A.uM(q),r)}else throw p}A.az("MqttBrowserWsConnection::connect - connection is waiting",!1)
return j.a},
axT(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b0(new B.ad($.aj,x.w),x.l)
A.az("MqttBrowserWsConnection::connectAuto - entered",!1)
w=null
try{w=B.oH(d)}catch(p){if(x.L.b(B.a_(p))){v=B.ag(p)
u="MqttBrowserWsConnection::connectAuto - The URI supplied for the WS connection is not valid - "+d
B.fN(A.uM(u),v)}else throw p}if(w.glv()!=="ws"&&w.glv()!=="wss")throw B.f(A.uM("MqttBrowserWsConnection::connectAuto - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.Pp(e)
t=w.gq0()
A.az("MqttBrowserWsConnection::connectAuto -  WS URL is "+B.l(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a0<1,i>")
m=B.T(new B.a0(m,new A.aor(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.z6(new A.fD(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kg(s,"open",new A.aos(o,k,j),!1,n)
o.b=B.kg(s,"close",new A.aot(o,j),!1,n)
o.a=B.kg(s,"error",new A.aou(o,j),!1,n)}catch(p){if(x.L.b(B.a_(p))){r=B.ag(p)
q="MqttBrowserWsConnection::connectAuto - The connection to the message broker {"+B.l(t)+"} could not be made."
B.fN(A.uM(q),r)}else throw p}A.az("MqttBrowserWsConnection::connectAuto - connection is waiting",!1)
return j.a},
vq(){var w,v,u
for(w=this.b,v=w.length,u=0;u<w.length;w.length===v||(0,B.y)(w),++u)w[u].aD()
D.b.M(w)},
CE(){var w=this.a
if(w!=null)w.close()},
aG5(){var w,v=this,u=v.a
if(u==null)throw B.f(B.aF("webSocket is null"))
w=x.m
return B.b([B.kg(u,"close",new A.aoz(v),!1,w),B.kg(u,"message",new A.aoA(v),!1,w),B.kg(u,"error",new A.aoB(v),!1,w)],x.d)}}
A.axe.prototype={
ue(d,e,f){return this.aDQ(d,e,f)},
aDQ(d,e,a0){var w=0,v=B.K(x.e),u,t=2,s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f
var $async$ue=B.E(function(a1,a2){if(a1===1){s.push(a2)
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
j.a=C.ya
j.b=C.cy
if(!r.f){i=new A.aoq(C.Ov,B.b([],o),p)
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
return B.L(j.x9(d,e),$async$ue)
case 13:w=11
break
case 12:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connectAuto",!1)
j=r.ay
j===$&&B.a()
w=14
return B.L(j.axT(d,e),$async$ue)
case 14:case 11:t=2
w=9
break
case 7:t=6
f=s.pop()
if(q.b(B.a_(f)))if(r.f)A.az("SynchronousMqttBrowserConnectionHandler::internalConnect exception thrown during auto reconnect - ignoring",!1)
else throw f
else throw f
w=9
break
case 6:w=2
break
case 9:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - connection complete",!1)
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect sending connect message",!1)
r.kK(a0)
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - pre sleep, state = "+r.cy.k(0),!1)
j=r.Q
j===$&&B.a()
if(!j.d){j.b=new B.b0(new B.ad($.aj,n),m)
j.c=B.cm(B.e4(0,j.a,0),j.gau5())
j.d=!0}j=j.b
j===$&&B.a()
w=15
return B.L(j.a,$async$ue)
case 15:++k
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - post sleep, state = "+r.cy.k(0),!1)
if(r.cy.a!==C.bY)if(!r.f)A.az("SynchronousMqttBrowserConnectionHandler::internalConnect failed, attempt "+k,!1)
j=r.cy.a!==C.bY
case 4:if(j&&k<l){w=3
break}case 5:if(j)if(!r.f){A.az("SynchronousMqttBrowserConnectionHandler::internalConnect failed",!1)
q=r.cy.b
l="The maximum allowed connection attempts ({"+l
if(q===C.cy)throw B.f(A.uM(l+"}) were exceeded. The broker is not responding to the connection request message (Missing Connection Acknowledgement?"))
else throw B.f(A.uM(l+"}) were exceeded. The broker is not responding to the connection request message correctly The return code is "+B.l(q)))}A.az("SynchronousMqttBrowserConnectionHandler::internalConnect exited with state "+r.cy.k(0),!1)
r.cx=!0
u=r.cy
w=1
break
case 1:return B.I(u,v)
case 2:return B.H(s.at(-1),v)}})
return B.J($async$ue,v)}}
A.aoo.prototype={
CJ(){var w=0,v=B.K(x.F),u,t=this,s,r,q
var $async$CJ=B.E(function(d,e){if(d===1)return B.H(e,v)
for(;;)switch(w){case 0:t.d=$.aX6=!0
s=new A.agi(new B.en(null,null,x.J))
t.k1=s
s.qT(x.u).e3(t.gazU())
r=t.k1
if(r!=null)r.qT(x.o).e3(t.gazS())
r=t.k1
q=new A.axe(3,r,B.o(x.q,x.i),B.b([],x.B),new A.jV(C.cd,C.cy,C.ex))
q.Q=new A.UZ(5000)
r.qT(x.h).e3(q.gaww())
r.qT(x.W).e3(q.gaFi())
r.qT(x._).e3(q.gaxR())
t.y=q
w=3
return B.L(t.a9X(null,null),$async$CJ)
case 3:u=e
w=1
break
case 1:return B.I(u,v)}})
return B.J($async$CJ,v)}}
A.GK.prototype={
H(){return"MqttDisconnectionOrigin."+this.b}}
A.z8.prototype={
H(){return"MqttConnectionState."+this.b}}
A.V2.prototype={
OH(){var w=this
w.vq()
w.CE()
w.a=null
if(w.e!=null){A.az("MqttConnectionBase::_onDone - calling disconnected callback",!1)
w.e.$0()}}}
A.V3.prototype={
xa(d,e,f){return this.axP(d,e,f)},
axP(d,e,f){var w=0,v=B.K(x.e),u,t=2,s=[],r=this,q,p,o
var $async$xa=B.E(function(g,h){if(g===1){s.push(h)
w=t}for(;;)switch(w){case 0:r.r=d
r.w=e
A.az("MqttConnectionHandlerBase::connect - server "+d+", port "+e,!1)
r.x=f
t=4
w=7
return B.L(r.ue(d,e,f),$async$xa)
case 7:q=r.cy
u=q
w=1
break
t=2
w=6
break
case 4:t=3
o=s.pop()
if(x.L.b(B.a_(o))){r.cy.a=C.RI
throw o}else throw o
w=6
break
case 3:w=2
break
case 6:case 1:return B.I(u,v)
case 2:return B.H(s.at(-1),v)}})
return B.J($async$xa,v)},
Cq(d){return this.awx(d)},
awx(d){var w=0,v=B.K(x.H),u,t=this,s,r
var $async$Cq=B.E(function(e,f){if(e===1)return B.H(f,v)
for(;;)switch(w){case 0:A.az("MqttConnectionHandlerBase::autoReconnect entered",!1)
s=t.f
if(s){w=1
break}t.f=!0
s=t.ay
s===$&&B.a()
s.vq()
s.CE()
s.a=null
t.ay.e=null
A.az("MqttConnectionHandlerBase::autoReconnect - attempting reconnection",!1)
s=t.r
s.toString
r=t.w
r.toString
w=3
return B.L(t.xa(s,r,t.x),$async$Cq)
case 3:r=f
t.cy=r
t.f=!1
s=t.as
if(r.a===C.bY){t.ay.e=t.b
s.toString
A.z9(s,new A.A2(!0))
A.az("MqttConnectionHandlerBase::autoReconnect - auto reconnect complete",!1)}else{A.az("MqttConnectionHandlerBase::autoReconnect - auto reconnect failed - re trying",!1)
s.toString
A.z9(s,new A.x8())}case 1:return B.I(u,v)}})
return B.J($async$Cq,v)},
kK(d){var w,v,u,t,s
A.az("MqttConnectionHandlerBase::sendMessage",!1)
w=this.cy.a
if(w===C.bY||w===C.ya){v=new A.z6(new A.fD(new Uint8Array(0),0))
d.i8(v)
w=v.a.b
if(0<=w)v.b=0
else v.b=w
A.az("MqttConnectionHandlerBase::sendMessage = message is "+d.k(0),!1)
w=this.ay
w===$&&B.a()
u=J.rT(D.l.gbc(v.jF(v.a.b).a),0,null)
w=w.a
if(w!=null){t=B.a6(u)
t.toString
w.send(t)}for(w=this.CW,t=w.length,s=0;s<w.length;w.length===t||(0,B.y)(w),++s)w[s].$1(d)}else A.az("MqttConnectionHandlerBase::sendMessage - not connected",!1)},
aFj(d){var w,v=d.a,u=v.a.a
A.az("MqttConnectionHandlerBase::messageAvailable - message type is "+B.l(u),!1)
u.toString
w=this.ch.i(0,u)
if(w!=null)w.$1(v)
else A.az("MqttConnectionHandlerBase::messageAvailable - WARN - no registered callback for this message type",!1)},
axQ(d){var w,v,u,t,s=this,r=y.B
A.az("MqttConnectionHandlerBase::_connectAckProcessor",!1)
try{w=x.N.a(d)
v=w.b
v===$&&B.a()
u=!0
if(v.f!==C.aM){v=w.b
v===$&&B.a()
if(v.f!==C.y7){v=w.b
v===$&&B.a()
if(v.f!==C.y6){v=w.b
v===$&&B.a()
if(v.f!==C.y9){v=w.b
v===$&&B.a()
v=v.f===C.y8}else v=u}else v=u}else v=u}else v=u
if(v){A.az("MqttConnectionHandlerBase::_connectAckProcessor connection rejected",!1)
v=s.cy
u=w.b
u===$&&B.a()
v.b=u.f
A.az(r,!1)
s.cy.a=C.cd}else{A.az("MqttConnectionHandlerBase:_connectAckProcessor - state = connected",!1)
v=s.cy
v.a=C.bY
v.b=C.y5}}catch(t){if(x.L.b(B.a_(t))){A.az(r,!1)
s.cy.a=C.cd}else throw t}A.az("MqttConnectionHandlerBase:: cancelling connect timer",!1)
v=s.Q
v===$&&B.a()
if(v.d){u=v.c
u===$&&B.a()
u.aD()
v.d=!1
v=v.b
v===$&&B.a()
v.e8()}return!0},
axS(d){var w=d.a
w.toString
this.axQ(w)}}
A.V4.prototype={
aGS(){var w,v,u,t,s,r=this
A.az("MqttConnectionKeepAlive::pingRequired",!1)
if(r.z)return!1
else r.z=!0
w=!1
u=new A.GL()
t=new A.it(C.aQ)
t.a=C.j0
u.a=t
v=u
t=r.y
t===$&&B.a()
if(t.cy.a===C.bY){A.az("MqttConnectionKeepAlive::pingRequired - sending ping request",!1)
try{r.y.kK(v)
w=!0
r.as=Date.now()}catch(s){A.az("MqttConnectionKeepAlive::pingRequired - exception occurred",!1)}}else A.az("MqttConnectionKeepAlive::pingRequired - NOT sending ping - not connected",!1)
A.az("MqttConnectionKeepAlive::pingRequired - restarting ping timer",!1)
t=r.a
t===$&&B.a()
r.c=B.cm(B.e4(0,t,0),r.ga53())
if(r.b!==0){t=r.d
if(t==null){A.az("MqttConnectionKeepAlive::pingRequired - starting disconnect timer",!1)
if(w)r.d=B.cm(B.e4(0,r.b,0),r.ga4D())
else r.a4C()}else{t=t.b
if(t==null)if(w){A.az("MqttConnectionKeepAlive::pingRequired - restarting disconnect timer",!1)
r.d=B.cm(B.e4(0,r.b,0),r.ga4D())}else r.a4C()
else A.az("MqttConnectionKeepAlive::pingRequired - disconnect timer is active, not restarting",!1)}}r.z=!1
return w},
aGR(d){var w,v=this
A.az("MqttConnectionKeepAlive::pingRequestReceived",!1)
if(v.z)return!1
else v.z=!0
d=new A.GM()
w=new A.it(C.aQ)
w.a=C.j1
d.a=w
w=v.y
w===$&&B.a()
w.kK(d)
v.z=!1
return!0},
aGU(d){var w,v,u,t=this
A.az("MqttConnectionKeepAlive::pingResponseReceived",!1)
w=Date.now()-t.as
t.r=w
v=++t.Q
u=t.w
t.w=u+D.d.jS(w-u,v)
w=t.d
if(w!=null)w.aD()
return!0},
aFl(d){return!0},
aFE(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.bY){A.az("MqttConnectionKeepAlive::noPingResponseReceived - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.z9(w,new A.y_())
A.az("MqttConnectionKeepAlive::noPingResponseReceived - OK - disconnect event fired",!1)}else A.az("MqttConnectionKeepAlive::noPingResponseReceived - ERROR - disconnect event not fired, no event handler",!1)}else A.az("MqttConnectionKeepAlive::noPingResponseReceived - not disconnecting, not connected",!1)},
a4C(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.bY){A.az("MqttConnectionKeepAlive::noMessageSent - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.z9(w,new A.xZ())
A.az("MqttConnectionKeepAlive::noMessageSent - OK - disconnect event fired",!1)}else A.az("MqttConnectionKeepAlive::noMessageSent - ERROR - disconnect event not fired, no event handler",!1)}else A.az("MqttConnectionKeepAlive::noMessageSent - not disconnecting, not connected",!1)}}
A.dR.prototype={
lr(d){var w,v,u
A.b9l(d)
w=D.am.bF(d)
v=w.length
if(v>65535)throw B.f(B.c3("MqttUtf8Encoding::toUtf8 -  UTF8 string length is invalid, length is "+v))
u=new A.fD(new Uint8Array(0),0)
u.ol(v>>>8)
u.ol(v&255)
u.N(0,w)
return u}}
A.Rf.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.Rz.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.TY.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.U5.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.U6.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.U7.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.Vq.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibr:1}
A.V_.prototype={
axU(){var w=this,v=w.a?1:0,u=w.b?1:0,t=w.c?1:0,s=w.d,r=w.e?1:0,q=w.f?1:0,p=w.r?1:0
return(v|u<<1|t<<2|s.a<<3|r<<5|q<<6|p<<7)>>>0},
k(d){var w=this
return"Connect Flags: Reserved1="+w.a+", CleanStart="+w.b+", WillFlag="+w.c+", WillQos="+w.d.k(0)+", WillRetain="+w.e+", PasswordFlag="+w.f+", UserNameFlag="+w.r}}
A.GI.prototype={
a0J(d,e){return this},
i8(d){var w,v,u,t,s,r,q,p=this,o=p.a
o.toString
w=new A.dR().lr(p.b.b).b
v=p.c
v===$&&B.a()
u=new A.dR()
t=u.lr(v.e).b
s=v.a
r=s.d
r===$&&B.a()
if(r.c){r=v.b
r.toString
r=u.lr(r).b
q=v.c
q.toString
t=t+r+u.lr(q).b}if(s.d.r){r=v.d
r.toString
t+=u.lr(r).b}if(s.d.f){v=v.f
v.toString
t+=u.lr(v).b}o.kJ(w+1+1+2+t,d)
o=p.b
A.qd(d,o.b)
d.nA(o.c)
v=o.d
v===$&&B.a()
d.nA(v.axU())
d.mq(o.e)
o=p.c
A.qd(d,o.e)
v=o.a
s=v.d
s===$&&B.a()
if(s.c){s=o.b
s.toString
A.qd(d,s)
s=o.c
s.toString
A.qd(d,s)}if(v.d.r){s=o.d
s.toString
A.qd(d,s)}if(v.d.f){o=o.f
o.toString
A.qd(d,o)}},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(y.h+u.e+"\n")
return u.charCodeAt(0)==0?u:u}}
A.V0.prototype={
sCD(d){var w,v=d.length
if(v>65535){w=new A.Rf()
w.a="mqtt-client::ClientIdentifierException: Client id "+d+" is too long at "+v+", Maximum ClientIdentifier length is 65535"
throw B.f(w)}this.e=d},
k(d){return y.h+this.e}}
A.mg.prototype={
H(){return"MqttConnectReturnCode."+this.b}}
A.V1.prototype={
it(d){var w=this
w.aHw(d)
w.aHx(d)
w.aHo(d)
w.aHt(d)},
k(d){var w=this,v=w.b,u=w.c,t=w.d
t===$&&B.a()
return"Connect Variable Header: ProtocolName="+v+", ProtocolVersion="+u+", ConnectFlags="+t.k(0)+", KeepAlive="+w.e}}
A.GH.prototype={
i8(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kJ(2,d)
w=this.b
if(w.y)d.nA(1)
else d.nA(0)
d.nA(w.f.a)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.t+v.y+"}, ReturnCode={"+v.f.k(0)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.aoD.prototype={
it(d){d.fZ()
this.aHy(d)},
k(d){return y.t+this.y+"}, ReturnCode={"+this.f.k(0)+"}"}}
A.GJ.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.it.prototype={
kJ(d,e){var w,v,u,t,s,r=this
r.e=d
w=new A.fD(new Uint8Array(0),0)
v=r.a.a
u=r.b?1:0
t=r.c
s=r.d?1:0
w.ol((v<<4>>>0)+(u<<3>>>0)+(t.a<<1>>>0)+s)
w.N(0,r.a7g())
e.jJ(w)},
it(d){var w,v,u,t,s,r=this,q="The header being processed contained an invalid size byte pattern. Message size must take a most 4 bytes, and the last byte must have bit 8 set to 0."
if(d.a.b<2){d.b=0
throw B.f(A.ak4("The supplied header is invalid. Header must be at least 2 bytes long."))}u=d.fZ()
r.d=(u&1)===1
r.c=A.aoP(u>>>1&3)
r.b=(u>>>3&1)===1
r.a=C.NT[u>>>4&15]
try{r.e=A.b9m(A.b9n(d))}catch(t){s=B.a_(t)
if(x.L.b(s)){w=B.ag(t)
B.fN(A.ak4(q),w)}else if(x.C.b(s)){v=B.ag(t)
B.fN(A.ak4(q),v)}else throw t}},
a7g(){var w,v,u=new A.fD(new Uint8Array(0),0),t=this.e
do{w=D.d.aV(t,128)
t=D.d.bM(t,128)
v=t>0
u.ol(v?(w|128)>>>0:w)}while(v)
return u},
k(d){var w=this
return"Header: MessageType = "+B.l(w.a)+", Duplicate = "+w.b+", Retain = "+w.d+", Qos = "+w.c.k(0)+", Size = "+w.e}}
A.dz.prototype={
i8(d){this.a.kJ(0,d)},
it(d){return},
k(d){var w="MQTTMessage of type "+(J.bb(this.a.a)+"\n")+(J.bb(this.a)+"\n")
return w.charCodeAt(0)==0?w:w}}
A.fi.prototype={
H(){return"MqttMessageType."+this.b}}
A.aoE.prototype={}
A.aoQ.prototype={
hF(){this.b="MQIsdp"
this.c=3
this.d=new A.V_(C.aQ)},
aHw(d){var w=A.z7(d)
this.b=w
this.a=this.a+(w.length+2)},
aHx(d){this.c=d.fZ();++this.a},
aHt(d){this.e=d.a5n()
this.a+=2},
aHy(d){this.f=C.Nl[d.fZ()];++this.a},
aHz(d){var w=A.z7(d)
this.r=w
this.a=w.length+2},
nr(d){this.w=d.a5n()
this.a+=2},
aHo(d){var w=new A.V_(C.aQ),v=d.fZ()
w.a=(v&1)===1
w.b=(v&2)===2
w.c=(v&4)===4
w.d=A.aoP(D.d.aG(v,3)&3)
w.e=(v&32)===32
w.f=(v&64)===64
w.r=(v&128)===128
this.d=w;++this.a},
gE(d){return this.a}}
A.GL.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.GM.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.uH.prototype={
i8(d){var w,v,u=this,t=u.b,s=new A.dR().lr(t.r).b
t=t.y.c
if(t===C.bF||t===C.ey)s+=2
t=u.c
t===$&&B.a()
t=t.c
t===$&&B.a()
w=t.b
u.a.kJ(s+w,d)
t=u.b
A.qd(d,t.r)
v=t.y.c
if(v===C.bF||v===C.ey){t=t.w
t.toString
d.mq(t)}t=u.c.c
t===$&&B.a()
d.jJ(t)},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=u.c
u===$&&B.a()
u=w+(v+"\n")+("Payload: {"+u.b+" bytes={"+A.aXa(u)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.V7.prototype={
k(d){var w=this.c
w===$&&B.a()
return"Payload: {"+w.b+" bytes={"+A.aXa(w)}}
A.Va.prototype={
it(d){var w
this.aHz(d)
w=this.y.c
if(w===C.bF||w===C.ey)this.nr(d)},
k(d){return"Publish Variable Header: TopicName={"+this.r+"}, MessageIdentifier={"+B.l(this.w)+"}, VH Length={"+this.a+"}"}}
A.za.prototype={
i8(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kJ(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.p+B.l(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.V5.prototype={
k(d){return y.p+B.l(this.w)+"}"}}
A.zb.prototype={
i8(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kJ(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.w+B.l(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.V6.prototype={
k(d){return y.w+B.l(this.w)+"}"}}
A.zc.prototype={
i8(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kJ(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.g+B.l(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.V8.prototype={
k(d){return y.g+B.l(this.w)+"}"}}
A.zd.prototype={
i8(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kJ(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.i+B.l(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.V9.prototype={
k(d){return y.i+B.l(this.w)+"}"}}
A.GO.prototype={
i8(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kJ(2+w.Go(),d)
w=v.b.w
w.toString
d.mq(w)
v.c.i8(d)},
aIE(d){var w
this.d=d
w=this.c
w===$&&B.a()
w.c.h(0,d,C.aQ)
return this},
awj(d){var w=this,v=w.c
v===$&&B.a()
if(v.c.G(w.d))w.c.c.h(0,w.d,d)
return w},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.Vb.prototype={
i8(d){this.c.ai(0,new A.aoL(d))},
it(d){var w,v,u,t,s,r,q=null,p=this.b.e-this.a.a
for(w=this.c,v=0;v<p;){u=d.jF(2)
if(u.b<2)B.S(B.c3(y.z))
if(u.gE(0)===0)B.S(B.cw())
t=u.i(0,0)
if(1>=u.b)B.S(B.yz(1,u,q,q,q))
s=d.jF((t<<8>>>0)+u.a[1])
r=new B.rI(!1).vR(s.dS(s),0,q,!0)
v+=r.length+3
w.h(0,r,A.aoP(d.fZ()))}},
Go(){var w={}
w.a=0
this.c.ai(0,new A.aoJ(w,new A.dR()))
return w.a},
k(d){var w=new B.cO(""),v=this.c
w.a="Payload: Subscription [{"+v.a+"}]\n"
v.ai(0,new A.aoK(w))
v=w.a
return v.charCodeAt(0)==0?v:v}}
A.Vc.prototype={
k(d){return"Subscribe Variable Header: MessageIdentifier={"+B.l(this.w)+"}"}}
A.GN.prototype={
i8(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kJ(2+w.c.length,d)
w=v.b.w
w.toString
d.mq(w)
v.c.i8(d)},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.aoH.prototype={
i8(d){var w,v,u
for(w=this.c,v=w.length,u=0;u<w.length;w.length===v||(0,B.y)(w),++u)d.nA(w[u].a)},
it(d){var w,v,u=this.b.e-this.a.a
for(w=this.c,v=0;v<u;){++v
w.push(A.aoP(d.fZ()))}},
k(d){var w,v=this.c,u=v.length,t="Payload: Qos grants [{"+u+"}]\n"
for(w=0;w<v.length;v.length===u||(0,B.y)(v),++w)t+="{{ Grant={"+v[w].k(0)+"} }}\n"
return t.charCodeAt(0)==0?t:t}}
A.aoI.prototype={
k(d){return"SubscribeAck Variable Header: MessageIdentifier={"+B.l(this.w)+"}"}}
A.Vd.prototype={
i8(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kJ(2+w.Go(),d)
w=v.b.w
w.toString
d.mq(w)
D.b.ai(v.c.c,d.gaJl())},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.aoN.prototype={
it(d){var w,v,u,t,s,r,q=null,p=this.b.e-this.a.a
for(w=this.c,v=0;v<p;){u=d.jF(2)
if(u.b<2)B.S(B.c3(y.z))
if(u.gE(0)===0)B.S(B.cw())
t=u.i(0,0)
if(1>=u.b)B.S(B.yz(1,u,q,q,q))
s=d.jF((t<<8>>>0)+u.a[1])
r=new B.rI(!1).vR(s.dS(s),0,q,!0)
v+=r.length+2
w.push(r)}},
Go(){var w,v,u,t,s=new A.dR()
for(w=this.c,v=w.length,u=0,t=0;t<w.length;w.length===v||(0,B.y)(w),++t)u+=s.lr(w[t]).b
return u},
k(d){var w,v=this.c,u=v.length,t="Payload: Unsubscription [{"+u+"}]\n"
for(w=0;w<u;++w)t+="{{ Topic={"+v[w]+"}}\n"
return t.charCodeAt(0)==0?t:t}}
A.aoO.prototype={
k(d){return"Unsubscribe VariableHeader Variable Header: MessageIdentifier={"+B.l(this.w)+"}"}}
A.GP.prototype={
i8(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kJ(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.k+B.l(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.aoM.prototype={
k(d){return y.k+B.l(this.w)+"}"}}
A.GG.prototype={
ga1j(){var w=this.y
return w!=null?w.cy:this.ch},
sMi(d){var w
this.CW=d
w=d.b
if(w!=null)w.c=3
w=d.b
if(w!=null)w.b="MQIsdp"},
x9(d,e){return this.axO(d,e)},
axO(d,e){var w=0,v=B.K(x.F),u,t=this,s,r,q,p,o,n,m
var $async$x9=B.E(function(f,g){if(f===1)return B.H(g,v)
for(;;)switch(w){case 0:if(!t.d){s=new A.TY()
s.a="mqtt-client::ClientIncorrectInstantiationException: Incorrect instantiation, do notinstantiate MqttClient directly, use MqttServerClient or MqttBrowserClient"
throw B.f(s)}$.aX8=$.aX8+1
s=t.CW
if(s!=null)s.a0J(d,e)
r=t.y
if(r==null)throw B.f(B.aF("connectionHandler is null"))
s=t.z
if(s!=null)r.at=s
r.b=t.gaDS()
r.e=r.d=r.c=r.a=null
A.az("MqttClient::connect - Connection timeout period is 5000 milliseconds",!1)
s=t.k1
q=$.b32()
p=x.S
o=x.c
s=new A.Wz(q,B.o(p,o),B.o(p,o),B.o(x.I,o),B.o(x.E,x.K),r,new B.en(null,null,x.U),s)
o=r.ch
o.h(0,C.j3,s.gaCt())
o.h(0,C.j2,s.gaCr())
o.h(0,C.j6,s.gaCv())
o.h(0,C.j5,s.gaCz())
o.h(0,C.j4,s.gaCx())
t.ay=s
s.r=!1
s=t.k1
n=x.Z
q=new A.YF(q,B.o(p,n),B.o(p,n),B.o(p,n),r,s,new B.hk(null,null,x.M))
o.h(0,C.mR,q.gaxK())
o.h(0,C.mN,q.gaxM())
s.qT(x.b).e3(q.gaH6())
s.qT(x.k).e3(q.gas5())
t.Q=q
q.x=q.w=q.r=null
q.y=!0
s=t.at
if(s!==0){A.az("MqttClient::connect - keep alive is enabled with a value of "+s+" seconds",!1)
s=t.k1
q=t.at
p=new A.V4()
p.y=r
p.x=s
p.a=q*1000
o.h(0,C.j0,p.gaGQ())
o.h(0,C.j1,p.gaGT())
r.CW.push(p.gaFk())
p.c=B.cm(B.e4(0,p.a,0),p.ga53())
A.az("MqttConnectionKeepAlive:: Initialised with a keep alive value of "+q+" seconds",!1)
A.az("MqttConnectionKeepAlive:: Disconnect on no ping response is disabled",!1)
t.as=p}else A.az("MqttClient::connect - keep alive is disabled",!1)
m=t.CW
if(m==null){s=A.aX7()
q=s.c
q===$&&B.a()
q.sCD(t.c)
q=s.b.d
q===$&&B.a()
q.d=C.aQ
m=s.a0J(d,e)
s=m.b.d
s===$&&B.a()
s.b=!0
t.sMi(m)}s=m.c
s===$&&B.a()
if(s.e.length===0)s.sCD(t.c)
s=m.b
if(s!=null)s.e=t.at
t.sMi(m)
u=r.xa(t.a,t.b,m)
w=1
break
case 1:return B.I(u,v)}})
return B.J($async$x9,v)},
aH5(d,e,f,g){var w,v,u,t,s,r,q,p,o,n,m=null,l=this.y,k=l==null
if((k?m:l.cy.a)!==C.bY)throw B.f(A.aUM(k?m:l.cy.a))
try{w=A.aQV(d)
l=this.ay
l.toString
k=w.a
A.az("PublishingManager::publish - entered with topic "+k,!1)
t=l.a.Gi()
s=new A.uH()
r=new A.it(C.aQ)
r.a=C.j2
s.a=r
q=new A.Va(r,C.aM,new A.dR())
q.hF()
s.b=q
p=new A.V7(m,m)
o=new A.fD(new Uint8Array(0),0)
p.c=o
s.c=p
q.r=k
q.w=t
r.c=e
o.N(0,f)
r.d=!0
if(e===C.bF||e===C.ey)l.b.h(0,t,s)
l.f.kK(s)
return t}catch(n){l=B.a_(n)
if(x.L.b(l)){v=l
u=B.ag(n)
l=new A.U7()
l.a="mqtt-client::InvalidTopicException: Topic "+d+" is "+J.bb(v)
B.fN(l,u)}else throw n}},
azV(d){var w
A.az("MqttClient::_disconnectOnNoPingResponse - disconnecting, no ping request response for 0 seconds",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.OH()}this.O4()},
azT(d){var w
A.az("MqttClient::disconnectOnNoMessageSent - disconnecting, no message sent due to exception like socket exception",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.OH()}this.O4()},
O4(){var w=this.y
if(w==null){A.az("MqttClient::internalDisconnect - not invoking disconnect, no connection handler",!1)
return}if(w.cx)this.Il(!0)},
Il(d){var w,v,u,t,s=this
if(!d){w=s.y
if(w!=null){A.az("MqttConnectionHandlerBase::disconnect - entered",!1)
if(w.cy.a===C.bY){v=new A.GJ()
u=new A.it(C.aQ)
u.a=C.mO
v.a=u
w.kK(v)}A.az(y.B,!1)
w.cy.a=C.cd}w=s.y
if(w!=null){v=w.ay
v===$&&B.a()
v.vq()
w.ay.CE()}t=C.RK}else t=C.RJ
w=s.ay
if(w!=null)w.x.b1()
s.ay=null
w=s.Q
if(w!=null)w.Q.b1()
s.Q=null
w=s.as
if(w!=null){A.az("MqttConnectionKeepAlive::stop - stopping keep alive",!1)
w.c.aD()
v=w.d
if(v!=null)v.aD()
w.Q=w.w=w.r=0}s.as=null
w=s.ch
v=s.ga1j().b
w.b=v
s.y=null
v=s.k1
if(v!=null)v.a.b1()
s.k1=null
w.a=C.cd
w.c=t
w=s.cx
if(w!=null)w.$0()}}
A.jV.prototype={
k(d){return"Connection status is "+this.a.H().split(".")[1]+" with return code of "+J.bb(this.b).split(".")[1]+" and a disconnection origin of "+this.c.H().split(".")[1]}}
A.z2.prototype={}
A.xJ.prototype={}
A.qa.prototype={}
A.x8.prototype={}
A.A2.prototype={}
A.y_.prototype={}
A.xZ.prototype={}
A.anM.prototype={
Gi(){var w=++this.a
return w===32768?this.a=1:w}}
A.kL.prototype={
H(){return"MqttQos."+this.b}}
A.nZ.prototype={}
A.Wy.prototype={}
A.Wz.prototype={
aCu(d){var w,v=x.z.a(d).b
v===$&&B.a()
w=v.w
A.az("PublishingManager::handlePublishAcknowledgement for message id "+B.l(w),!1)
v=this.b
if(v.G(w)){w.toString
this.X0(v.i(0,w))
v.F(0,w)}return!0},
aCs(d){var w,v,u,t,s,r,q,p,o,n,m=this
x.c.a(d)
w=d
v=!0
try{u=A.aQV(w.b.r)
A.az("PublishingManager::handlePublish - publish received from broker with topic "+B.l(u),!1)
if(w.a.c===C.aQ){q=m.y
if(q!=null)A.z9(q,new A.qa(d,u))}else if(w.a.c===C.bF){q=m.y
if(q!=null)A.z9(q,new A.qa(d,u))
t=w.b.w
p=new A.za()
q=new A.it(C.aQ)
q.a=C.j3
p.a=q
q=new A.V5(C.aM,new A.dR())
q.hF()
p.b=q
q.w=t
s=p
m.f.kK(s)}else if(w.a.c===C.ey){q=m.d
if(!q.G(w.b.w))q.h(0,w.b.w,w)
o=new A.zc()
q=new A.it(C.aQ)
q.a=C.j4
o.a=q
q=new A.V8(C.aM,new A.dR())
q.hF()
o.b=q
q.w=w.b.w
r=o
m.f.kK(r)}}catch(n){if(x.L.b(B.a_(n)))v=!1
else throw n}return v},
aCA(d){var w,v,u,t,s,r,q,p=x.G.a(d).b
p===$&&B.a()
w=p.w
A.az("PublishingManager::handlePublishRelease - for message identifier "+B.l(w),!1)
v=!0
try{u=this.d.F(0,w)
if(u!=null){t=A.aQV(u.b.r)
p=this.y
if(p!=null)A.z9(p,new A.qa(u,t))
r=new A.zb()
p=new A.it(C.aQ)
p.a=C.j6
r.a=p
p=new A.V6(C.aM,new A.dR())
p.hF()
r.b=p
p.w=u.b.w
s=r
this.f.kK(s)}}catch(q){if(x.L.b(B.a_(q)))v=!1
else throw q}return v},
aCw(d){var w,v=x.a.a(d).b
v===$&&B.a()
w=v.w
A.az("PublishingManager::handlePublishComplete - for message identifier "+B.l(w),!1)
this.X0(this.b.F(0,w))
return!0},
aCy(d){var w,v,u
x.R.a(d)
w=d.b
w===$&&B.a()
v=w.w
A.az("PublishingManager::handlePublishReceived - for message identifier "+B.l(v),!1)
if(this.b.G(v)){u=new A.zd()
w=new A.it(C.aQ)
w.a=C.j5
u.a=w
w.c=C.bF
w=new A.V9(C.aM,new A.dR())
w.hF()
u.b=w
w.w=d.b.w
this.f.kK(u)}return!0},
X0(d){var w=this.x
if(w.d!=null&&d!=null){A.az("PublishingManager::_notifyPublish - adding message to published stream for topic "+d.b.r,!1)
A.aXb(w,d)}}}
A.Ay.prototype={
glj(){return this.w},
gra(){var w=this.x
return w},
gxI(){var w=this.e,v=B.Z(w).j("b4<1>")
w=B.T(new B.b4(w,new A.axa(),v),v.j("A.E"))
return w},
gzI(){var w=this.e,v=B.Z(w).j("b4<1>")
w=B.T(new B.b4(w,new A.axb(),v),v.j("A.E"))
return w},
gA(d){var w=D.c.gA(this.gra().a),v=B.fA(this.glj()),u=this.c?519018:218159
return w+v+u},
aIY(d){var w,v,u=this
if(d.length!==u.gxI().length+u.gzI().length)return!1
for(w=0;w<u.gxI().length+u.gzI().length;++w)u.e[w].slj(d[w])
v=D.b.ga4(u.e).glj()
if(!u.c)u.w=v
return!0},
l(d,e){var w,v=this
if(e==null)return!1
if(v!==e)w=e instanceof A.Ay&&B.p(v)===B.p(e)&&v.gra().a===e.gra().a&&v.glj()===e.glj()&&v.c===e.c&&v.b==e.b
else w=!0
return w},
k(d){var w=this,v="Subscription:: Batch: "+w.c+", MID: "+B.l(w.b)+", Topic: "+w.gra().a+", QoS: "+w.glj().k(0)+", Total Batch: "+(w.gxI().length+w.gzI().length)+"\n"
return v.charCodeAt(0)==0?v:v}}
A.YE.prototype={}
A.YF.prototype={
aIU(d){var w,v,u
for(w=this.b,w=new B.bv(w,w.r,w.e,B.k(w).j("bv<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}for(w=this.c,w=new B.bv(w,w.r,w.e,B.k(w).j("bv<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}return null},
a1F(d,e){var w,v,u,t,s,r,q,p
try{w=A.aRd(d)
v=this.a.Gi()
u=A.aRc()
u.x=w
r=u
if(!r.c)r.w=e
u.b=v
Date.now()
this.c.h(0,v,u)
r=A.aXc()
q=u.b
r.b.w=q
t=r.aIE(u.gra().a).awj(u.glj())
this.e.kK(t)
return u}catch(p){r=B.a_(p)
if(x.L.b(r)){s=r
A.az("SubscriptionsManager::createNewSubscription exception raised, text is "+B.l(s),!1)
return null}else throw p}},
azd(d){var w,v,u,t,s,r,q,p,o,n,m,l
try{w=A.aRd(D.b.ga4(d).gra())
v=this.a.Gi()
u=A.aRc()
u.c=!0
u.x=w
u.e=d
u.r=d
u.b=v
Date.now()
this.c.h(0,v,u)
q=A.aXc()
q.b.w=v
t=q
for(p=0;!1;++p){s=d[p]
o=t
n=s.gra()
o.d=n
o=o.c
o===$&&B.a()
o.c.h(0,n,C.aQ)
n=t
o=s.glj()
m=n.c
m===$&&B.a()
if(m.c.G(n.d))n.c.c.h(0,n.d,o)}this.e.kK(t)
return u}catch(l){o=B.a_(l)
if(x.L.b(o)){r=o
A.az("SubscriptionsManager::createNewBatchSubscription exception raised, text is "+B.l(r),!1)
return null}else throw l}},
aH7(d){A.aXb(this.Q,B.b([new A.nZ(d.a,x.X)],x.f))},
axL(d){var w,v,u,t
x.A.a(d)
w=d.b.w
w.toString
A.aRc()
v=this.c
if(v.G(w))u=v.i(0,w)
else{A.az("SubscriptionsManager::confirmSubscription Sub Ack received for non pending subscription",!1)
return!1}if(!u.c){t=d.c
t===$&&B.a()
t=t.c
if(t.length===0||D.b.ga4(t)===C.mS){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription failed for single subscription "+D.b.ga4(d.c.c).k(0),!1)
return!1}}else{t=d.c
t===$&&B.a()
if(!u.aIY(t.c)){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription failed to update qos grants for batch subscription, lengths differ","Requested: 0, Received: "+d.c.c.length)
return!1}if(d.c.c.length===0||u.gxI().length===u.gxI().length+u.gzI().length){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription all qos grants failed",!1)
return!1}}v.F(0,w)
this.b.h(0,w,u)
return!0},
axN(d){var w,v=x.D.a(d).b
v===$&&B.a()
w=v.w
v=this.d
if(v.G(w)){v.i(0,w)
this.b.F(0,null)}A.az("SubscriptionsManager::confirmUnsubscribe subscription not found in pending unsubscriptions",!1)
return!0},
as6(d){var w,v,u,t,s,r,q,p=this
A.az("Subscriptionsmanager::_resubscribe - resubscribing from auto reconnect "+d.a,!1)
w=p.b
v=B.k(w).j("bq<2>")
u=B.T(new B.bq(w,v),v.j("A.E"))
v=p.c
t=B.k(v).j("bq<2>")
s=B.T(new B.bq(v,t),t.j("A.E"))
w.M(0)
v.M(0)
w=B.T(u,x.Z)
D.b.N(w,s)
v=w.length
r=0
for(;r<w.length;w.length===v||(0,B.y)(w),++r){q=w[r]
if(q.c)p.azd(q.r)
else{t=q.x
p.a1F(t.a,q.glj())}}}}
A.oB.prototype={
gA(d){return D.c.gA(this.a)},
St(d,e){var w,v
this.b=B.b(this.a.split("/"[0]),x.s)
for(w=e.length,v=0;v<e.length;e.length===w||(0,B.y)(e),++v)e[v].$1(this)},
l(d,e){if(e==null)return!1
if(this===e)return!0
return e instanceof A.oB&&this.a===e.a},
k(d){return this.a}}
A.z6.prototype={
gE(d){return this.a.b},
aEj(){if(this.a.b-this.b>0)return!0
return!1},
fZ(){var w=this,v=w.a.i(0,w.b),u=w.b
if(u<=w.a.b-1)w.b=u+1
else return-1
return v},
a5n(){return(this.fZ()<<8>>>0)+this.fZ()},
jF(d){var w,v,u,t,s=this,r=null,q=s.a,p=q.b
if(p<d||s.b+d>p)throw B.f(B.c3("mqtt_client::ByteBuffer::read: The buffer does not have enough bytes for the read operation length "+s.gE(0)+", count "+d+", position "+s.b+", buffer "+q.k(q)))
if($.aX6){w=new A.fD(new Uint8Array(0),0)
p=s.b
v=p+d
B.dA(p,v,q.gE(0),r,r)
w.N(0,B.he(q,p,v,B.k(q).j("aP.E")))
s.b+=d
u=new A.fD(new Uint8Array(0),0)
u.N(0,w)
return u}else{p=s.b+=d
v=new A.fD(new Uint8Array(0),0)
t=p-d
B.dA(t,p,q.gE(0),r,r)
v.N(0,B.he(q,t,p,B.k(q).j("aP.E")))
return v}},
aHv(d){var w,v,u,t=this,s=t.a,r=s.b
if(r<d||t.b+d>r)throw B.f(B.c3("mqtt_client::ByteBuffer::readPayload: The buffer does not have enough bytes for the read operation length "+t.gE(0)+", count "+d+", position "+t.b+", buffer "+s.k(s)))
if(d<=32767)return t.jF(d)
r=t.b
if(r!==0){s.Fp(s,0,r)
s=t.b=0}else s=r
w=new A.fD(new Uint8Array(0),0)
r=t.a
v=r.b
if(v===d){t.b=v
s=new A.fD(new Uint8Array(0),0)
s.N(0,r)
return s}else{s+=d
B.dA(s,v,r.gE(0),null,null)
w.N(0,B.he(r,s,v,B.k(r).j("aP.E")).dS(0))
r=t.a
r.Fp(r,t.b+d,r.b)
u=new A.fD(new Uint8Array(0),0)
u.N(0,t.a)
t.a.sE(0,0)
t.a.N(0,w)
t.b=0
return u}},
nA(d){var w=this.a,v=w.b,u=this.b
if(v===u)w.ol(d)
else w.h(0,u,d);++this.b},
mq(d){this.nA(D.d.aG(d,8))
this.nA(d&255)},
jJ(d){this.a.N(0,d)
this.b=this.a.b},
aJm(d){A.qd(this,d)},
k(d){var w,v=this.a
v=v.ga9(v)
if(!v){v=this.a
w=B.m1(v.dS(v),"[","]")}else w="null or empty"
return w}}
A.aoC.prototype={
gE(d){return this.a.b},
avW(d){var w,v,u,t,s,r
for(w=new B.fK(d),v=x.V,w=new B.bN(w,w.gE(0),v.j("bN<aP.E>")),u=x.t,v=v.j("aP.E");w.v();){t=w.d
if(t==null)t=v.a(t)
if(t<=255&&t>=0)this.a.ol(t)
else{s=new Uint16Array(B.b1(B.b([t],u)))
t=this.a
r=J.b5i(D.yd.gbc(s))
t.a__(r,0,null)}}return this}}
A.UZ.prototype={
au6(){this.d=!1
var w=this.b
w===$&&B.a()
w.e8()}}
A.QQ.prototype={}
A.Vw.prototype={}
A.DP.prototype={}
A.AP.prototype={
gE(d){return this.b},
i(d,e){if(e>=this.b)throw B.f(B.yz(e,this,null,null,null))
return this.a[e]},
h(d,e,f){var w
if(e>=this.b)throw B.f(B.yz(e,this,null,null,null))
w=this.a
w.$flags&2&&B.a3(w)
w[e]=f},
sE(d,e){var w,v,u,t,s=this,r=s.b
if(e<r)for(w=s.a,v=w.$flags|0,u=e;u<r;++u){v&2&&B.a3(w)
w[u]=0}else{r=s.a.length
if(e>r){if(r===0)t=new Uint8Array(e)
else t=s.KU(e)
D.l.bK(t,0,s.b,s.a)
s.a=t}}s.b=e},
ol(d){var w,v=this,u=v.b
if(u===v.a.length)v.a_0(u)
u=v.a
w=v.b++
u.$flags&2&&B.a3(u)
u[w]=d},
t(d,e){var w,v=this,u=v.b
if(u===v.a.length)v.a_0(u)
u=v.a
w=v.b++
u.$flags&2&&B.a3(u)
u[w]=e},
tt(d,e,f,g){B.f5(f,"start")
this.a__(e,f,g)},
N(d,e){return this.tt(0,e,0,null)},
a__(d,e,f){var w,v,u
if(x.j.b(d))f=J.aS(d)
if(f!=null){this.aui(this.b,d,e,f)
return}for(w=J.bu(d),v=0;w.v();){u=w.gO()
if(v>=e)this.ol(u);++v}if(v<e)throw B.f(B.aF("Too few elements"))},
aui(d,e,f,g){var w,v,u,t,s=this
if(x.j.b(e)){w=J.a9(e)
if(f>w.gE(e)||g>w.gE(e))throw B.f(B.aF("Too few elements"))}v=g-f
u=s.b+v
s.auh(u)
w=s.a
t=d+v
D.l.bz(w,t,s.b+v,w,d)
D.l.bz(s.a,d,t,e,f)
s.b=u},
auh(d){var w,v=this
if(d<=v.a.length)return
w=v.KU(d)
D.l.bK(w,0,v.b,v.a)
v.a=w},
KU(d){var w=this.a.length*2
if(d!=null&&w<d)w=d
else if(w<8)w=8
return new Uint8Array(w)},
a_0(d){var w=this.KU(null)
D.l.bK(w,0,d,this.a)
this.a=w},
bz(d,e,f,g,h){var w=this.b
if(f>w)throw B.f(B.ct(f,0,w,null,null))
w=this.a
if(g instanceof A.fD)D.l.bz(w,e,f,g.a,h)
else D.l.bz(w,e,f,g,h)},
bK(d,e,f,g){return this.bz(0,e,f,g,0)}}
A.a2C.prototype={}
A.fD.prototype={}
var z=a.updateTypes(["F(dz?)","~(oB)","~()","~(i?,kL?)","F(aUh)","~(M<nZ<dz>>)","~(x8)","~(z2)","~(xJ)","F()","~(y_)","~(xZ)","~(qa)","~(A2)","~(i)"])
A.agj.prototype={
$1(d){return this.a.b(d)},
$S:561}
A.aoF.prototype={
$0(){var w=this.a
w.f=!1
if(!w.d)w.aI()},
$S:0}
A.aoG.prototype={
$1(d){var w,v=x.c.a(J.c2(d,0).b),u=v.c
u===$&&B.a()
u=u.c
u===$&&B.a()
w=A.b9q(u)
this.a.AS(w,this.b)},
$S:z+5}
A.aov.prototype={
$1(d){return d},
$S:47}
A.aow.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aD()
v=w.b
if(v!=null)v.aD()
w=w.a
if(w!=null)w.aD()
this.b.Zn()
return this.c.e8()},
$S:2}
A.aox.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aD()
v=w.b
if(v!=null)v.aD()
w=w.a
if(w!=null)w.aD()
return this.b.eI(new A.jV(C.cd,C.cy,C.ex))},
$S:2}
A.aoy.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket has erred",!1)
w=this.a
v=w.c
if(v!=null)v.aD()
v=w.b
if(v!=null)v.aD()
w=w.a
if(w!=null)w.aD()
return this.b.eI(new A.jV(C.cd,C.cy,C.ex))},
$S:2}
A.aor.prototype={
$1(d){return d},
$S:47}
A.aos.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aD()
v=w.b
if(v!=null)v.aD()
w=w.a
if(w!=null)w.aD()
this.b.Zn()
return this.c.e8()},
$S:2}
A.aot.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aD()
v=w.b
if(v!=null)v.aD()
w=w.a
if(w!=null)w.aD()
return this.b.eI(new A.jV(C.cd,C.cy,C.ex))},
$S:2}
A.aou.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket has errored",!1)
w=this.a
v=w.c
if(v!=null)v.aD()
v=w.b
if(v!=null)v.aD()
w=w.a
if(w!=null)w.aD()
return this.b.eI(new A.jV(C.cd,C.cy,C.ex))},
$S:2}
A.aoz.prototype={
$1(d){A.az("MqttBrowserConnection::_startListening - websocket is closed",!1)
this.a.OH()},
$S:2}
A.aoA.prototype={
$1(d){this.a.p8(d.data)},
$S:2}
A.aoB.prototype={
$1(d){var w
A.az("MqttBrowserConnection::_startListening - websocket has errored",!1)
w=this.a
w.vq()
w.CE()
w.a=null
if(w.e!=null){A.az("MqttConnectionBase::_onError - calling disconnected callback",!1)
w.e.$0()}},
$S:2}
A.aoL.prototype={
$2(d,e){var w=this.a
d.toString
A.qd(w,d)
w.nA(e.a)},
$S:z+3}
A.aoJ.prototype={
$2(d,e){var w,v=this.a,u=v.a
d.toString
w=u+this.b.lr(d).b
v.a=w
v.a=w+1},
$S:z+3}
A.aoK.prototype={
$2(d,e){var w=this.a,v="{{ Topic={"+B.l(d)+"}, Qos={"+B.l(e)+"} }}\n"
w.a+=v},
$S:z+3}
A.axa.prototype={
$1(d){d.glj()
return!1},
$S:z+4}
A.axb.prototype={
$1(d){d.glj()
return!0},
$S:z+4}
A.ax9.prototype={
$1(d){return(D.c.q(d,"#")||D.c.q(d,"+"))&&d.length>1},
$S:31};(function aliases(){var w=A.dz.prototype
w.RS=w.it
w.iD=w.k
w=A.GG.prototype
w.a9X=w.x9})();(function installTearOffs(){var w=a._instance_0u,v=a._static_1,u=a._instance_1u
w(A.j8.prototype,"gdh","m",2)
v(A,"biO","baC",1)
v(A,"biQ","bbT",1)
v(A,"biP","bbS",1)
v(A,"b1A","bcv",1)
v(A,"b1B","bcw",1)
var t
u(t=A.V3.prototype,"gaww","Cq",6)
u(t,"gaFi","aFj",7)
u(t,"gaxR","axS",8)
w(t=A.V4.prototype,"ga53","aGS",9)
u(t,"gaGQ","aGR",0)
u(t,"gaGT","aGU",0)
u(t,"gaFk","aFl",0)
w(t,"ga4D","aFE",2)
u(t=A.GG.prototype,"gazU","azV",10)
u(t,"gazS","azT",11)
w(t,"gaDS","O4",2)
u(t=A.Wz.prototype,"gaCt","aCu",0)
u(t,"gaCr","aCs",0)
u(t,"gaCz","aCA",0)
u(t,"gaCv","aCw",0)
u(t,"gaCx","aCy",0)
u(t=A.YF.prototype,"gaH6","aH7",12)
u(t,"gaxK","axL",0)
u(t,"gaxM","axN",0)
u(t,"gas5","as6",13)
u(A.z6.prototype,"gaJl","aJm",14)
w(A.UZ.prototype,"gau5","au6",2)})();(function inheritance(){var w=a.mixin,v=a.inheritMany,u=a.inherit
v(B.t,[A.agi,A.a3p,A.V2,A.V3,A.GG,A.V4,A.dR,A.Rf,A.Rz,A.TY,A.U5,A.U6,A.U7,A.Vq,A.V_,A.dz,A.aoE,A.aoQ,A.it,A.jV,A.z2,A.xJ,A.qa,A.x8,A.A2,A.y_,A.xZ,A.anM,A.DP,A.oB,A.Wz,A.Vw,A.YF,A.z6,A.aoC,A.UZ,A.QQ])
v(B.eF,[A.agj,A.aoG,A.aov,A.aow,A.aox,A.aoy,A.aor,A.aos,A.aot,A.aou,A.aoz,A.aoA,A.aoB,A.axa,A.axb,A.ax9])
u(A.j8,A.a3p)
u(A.aoF,B.hE)
u(A.UY,A.V2)
u(A.aop,A.V3)
u(A.aoq,A.UY)
u(A.axe,A.aop)
u(A.aoo,A.GG)
v(B.kf,[A.GK,A.z8,A.mg,A.fi,A.kL])
v(A.dz,[A.GI,A.GH,A.GJ,A.GL,A.GM,A.uH,A.za,A.zb,A.zc,A.zd,A.GO,A.GN,A.Vd,A.GP])
v(A.aoE,[A.V0,A.V7,A.Vb,A.aoH,A.aoN])
v(A.aoQ,[A.V1,A.aoD,A.Va,A.V5,A.V6,A.V8,A.V9,A.Vc,A.aoI,A.aoO,A.aoM])
v(B.ia,[A.aoL,A.aoJ,A.aoK])
u(A.nZ,A.DP)
v(A.oB,[A.Wy,A.YE])
u(A.Ay,A.Vw)
u(A.AP,B.aP)
u(A.a2C,A.AP)
u(A.fD,A.a2C)
w(A.a3p,B.aT)})()
B.jv(b.typeUniverse,JSON.parse('{"j8":{"aT":[],"ab":[]},"uH":{"dz":[]},"Ay":{"Vw":["DP"]},"Rf":{"br":[]},"Rz":{"br":[]},"TY":{"br":[]},"U5":{"br":[]},"U6":{"br":[]},"U7":{"br":[]},"Vq":{"br":[]},"GI":{"dz":[]},"GH":{"dz":[]},"GJ":{"dz":[]},"GL":{"dz":[]},"GM":{"dz":[]},"za":{"dz":[]},"zb":{"dz":[]},"zc":{"dz":[]},"zd":{"dz":[]},"GO":{"dz":[]},"GN":{"dz":[]},"Vd":{"dz":[]},"GP":{"dz":[]},"Wy":{"oB":[]},"YE":{"oB":[]},"AP":{"aP":["1"],"M":["1"],"aI":["1"],"A":["1"]},"a2C":{"AP":["m"],"aP":["m"],"M":["m"],"aI":["m"],"A":["m"]},"fD":{"AP":["m"],"aP":["m"],"M":["m"],"aI":["m"],"A":["m"],"aP.E":"m","A.E":"m"}}'))
B.rF(b.typeUniverse,JSON.parse('{"UY":1,"V2":1}'))
var y={t:"Connect Variable Header: SessionPresent={",a:"Guarded fire - event bus is closed - event not fired",h:"MqttConnectPayload - client identifier is : ",B:"MqttConnectionHandlerBase::_performConnectionDisconnect entered",p:"PublishAck Variable Header: MessageIdentifier={",w:"PublishComplete Variable Header: MessageIdentifier={",g:"PublishReceived Variable Header: MessageIdentifier={",i:"PublishRelease Variable Header: MessageIdentifier={",k:"UnsubscribeAck Variable Header: MessageIdentifier={",z:"mqtt_client::MQTTEncoding: Length byte array must comprise 2 bytes"}
var x=(function rtii(){var w=B.U
return{h:w("x8"),Q:w("QQ<DP>"),V:w("fK"),_:w("xJ"),o:w("xZ"),u:w("y_"),C:w("cs"),L:w("br"),y:w("n<aUh>"),r:w("n<nR>"),v:w("n<kL>"),f:w("n<nZ<dz>>"),p:w("n<blJ>"),d:w("n<hy<@>>"),s:w("n<i>"),t:w("n<m>"),B:w("n<F(dz?)>"),x:w("n<~(oB)>"),m:w("b7"),j:w("M<@>"),W:w("z2"),b:w("qa"),e:w("jV"),N:w("GH"),q:w("fi"),z:w("za"),a:w("zb"),c:w("uH"),R:w("zc"),G:w("zd"),X:w("nZ<dz>"),A:w("GN"),D:w("GP"),K:w("t"),k:w("A2"),P:w("c7<M<nZ<dz>>>"),Z:w("Ay"),E:w("hh"),U:w("en<uH>"),J:w("en<@>"),l:w("b0<jV?>"),Y:w("b0<~>"),w:w("ad<jV?>"),g:w("ad<~>"),M:w("hk<M<nZ<dz>>>"),S:w("m"),F:w("jV?"),n:w("kL?"),T:w("i?"),i:w("F(dz?)?"),I:w("m?"),H:w("~")}})();(function constants(){var w=a.makeConstList
C.y5=new A.mg(0,"connectionAccepted")
C.y6=new A.mg(1,"unacceptedProtocolVersion")
C.y7=new A.mg(2,"identifierRejected")
C.aM=new A.mg(3,"brokerUnavailable")
C.y8=new A.mg(4,"badUsernameOrPassword")
C.y9=new A.mg(5,"notAuthorized")
C.cy=new A.mg(6,"noneSpecified")
C.Nl=w([C.y5,C.y6,C.y7,C.aM,C.y8,C.y9,C.cy],B.U("n<mg>"))
C.RL=new A.fi(0,"reserved1")
C.mM=new A.fi(1,"connect")
C.mP=new A.fi(2,"connectAck")
C.j2=new A.fi(3,"publish")
C.j3=new A.fi(4,"publishAck")
C.j4=new A.fi(5,"publishReceived")
C.j5=new A.fi(6,"publishRelease")
C.j6=new A.fi(7,"publishComplete")
C.mQ=new A.fi(8,"subscribe")
C.mR=new A.fi(9,"subscribeAck")
C.yb=new A.fi(10,"unsubscribe")
C.mN=new A.fi(11,"unsubscribeAck")
C.j0=new A.fi(12,"pingRequest")
C.j1=new A.fi(13,"pingResponse")
C.mO=new A.fi(14,"disconnect")
C.RM=new A.fi(15,"reserved2")
C.NT=w([C.RL,C.mM,C.mP,C.j2,C.j3,C.j4,C.j5,C.j6,C.mQ,C.mR,C.yb,C.mN,C.j0,C.j1,C.mO,C.RM],B.U("n<fi>"))
C.Ov=w(["mqtt","mqttv3.1","mqttv3.11"],x.s)
C.Pc=w(["mqtt"],x.s)
C.cd=new A.z8(1,"disconnected")
C.ya=new A.z8(2,"connecting")
C.bY=new A.z8(3,"connected")
C.RI=new A.z8(4,"faulted")
C.RJ=new A.GK(0,"unsolicited")
C.RK=new A.GK(1,"solicited")
C.ex=new A.GK(2,"none")
C.aQ=new A.kL(0,"atMostOnce")
C.bF=new A.kL(1,"atLeastOnce")
C.ey=new A.kL(2,"exactlyOnce")
C.RN=new A.kL(3,"reserved1")
C.mS=new A.kL(4,"failure")
C.a3U=B.aH("@")})();(function staticFields(){$.aX6=!1
$.aX8=0})();(function lazyInitializers(){var w=a.lazyFinal
w($,"blD","b32",()=>new A.anM())})()};
(a=>{a["RnFFNho1eR9w9dkXIvUirvYHVRc="]=a.current})($__dart_deferred_initializers__);