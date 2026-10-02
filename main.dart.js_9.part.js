((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,E,A={agv:function agv(d){this.a=d},agw:function agw(d){this.a=d},
aXB(){var w=B.b([],x.r),v=$.cD,u=(v==null?$.cD=$.fI():v).fA("[DEFAULT]")
B.cO(u,$.fe(),!0)
v=B.yo(new B.eh(u))
v=new B.ahA(v)
return new A.ja(v,w,$.av())},
ja:function ja(d,e,f){var _=this
_.a=d
_.c=_.b=null
_.d=!1
_.e=e
_.r=_.f=!1
_.K$=0
_.V$=f
_.aj$=_.ah$=0},
aoW:function aoW(d,e){this.a=d
this.b=e},
aoX:function aoX(d,e){this.a=d
this.b=e},
a3x:function a3x(){},
V5:function V5(){},
aoG:function aoG(){},
aoH:function aoH(d,e,f){var _=this
_.as=d
_.a=null
_.b=e
_.d=$
_.e=null
_.f=f},
aoM:function aoM(){},
aoN:function aoN(d,e,f){this.a=d
this.b=e
this.c=f},
aoO:function aoO(d,e){this.a=d
this.b=e},
aoP:function aoP(d,e){this.a=d
this.b=e},
aoI:function aoI(){},
aoJ:function aoJ(d,e,f){this.a=d
this.b=e
this.c=f},
aoK:function aoK(d,e){this.a=d
this.b=e},
aoL:function aoL(d,e){this.a=d
this.b=e},
aoQ:function aoQ(d){this.a=d},
aoR:function aoR(d){this.a=d},
aoS:function aoS(d){this.a=d},
axv:function axv(d,e,f,g,h){var _=this
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
aoF:function aoF(d,e,f){var _=this
_.a=d
_.b=1883
_.c=e
_.d=!1
_.as=_.Q=_.z=_.y=null
_.at=0
_.ay=null
_.ch=f
_.k1=_.cx=_.CW=null},
b9W(d){var w,v
for(w=d.length,v=0;v<w;++v)if(d.charCodeAt(v)>127)throw B.e(B.ch("mqtt_client::MQTTEncoding: The input string has extended UTF characters, which are not supported"))},
aVe(d){var w=new A.RH()
w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation."
if(d!=null)w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation. Current state is "+d.H().split(".")[1]
return w},
akr(d){var w=new A.Uc()
w.a="mqtt-client::InvalidHeaderException: "+d
return w},
aWP(d){var w=new A.Ud()
w.a="mqtt-client::InvalidMessageException: "+d
return w},
uR(d){var w=new A.Vy()
w.a="mqtt-client::NoConnectionException: "+d
return w},
zb(d,e){var w=d.a
if((w.c&4)===0)w.t(0,e)
else A.az(y.a,!1)},
aXD(d,e){if((d.c&4)!==0){A.az("Guarded add - stream is closed - event not added",!1)
return}if(d.d==null)A.az("Guarded add - stream has no listeners - adding anyway",!1)
d.t(0,e)},
aXz(){var w=new A.GQ(),v=new A.it(C.aR)
v.a=C.mN
w.a=v
v=A.aQT()
w.b=v
A.aQT()
w.c=new A.V8(v)
return w},
aQT(){var w=new A.V9(C.aN,new A.dV())
w.hE()
return w},
b9Y(d){var w,v=new A.fD(new Uint8Array(0),0),u=0
do{w=d.h0()
v.oq(w);++u}while(u<=4&&(w&128)===128)
return v},
b9X(d){var w,v,u,t,s
for(w=B.l(d),v=new B.bN(d,d.gE(0),w.j("bN<aQ.E>")),w=w.j("aQ.E"),u=0,t=1;v.v();){s=v.d
u+=((s==null?w.a(s):s)&127)*t
t*=128}return u},
ba_(d){var w,v,u,t,s,r
try{w=new A.it(C.aR)
t=new A.it(C.aR)
t.is(d)
w=t
if(d.a.b-d.b<w.e){d.b=0
s=A.aWP("Available bytes is less than the message size")
throw B.e(s)}s=A.b9Z(w,d)
return s}catch(r){s=B.a_(r)
if(x.L.b(s)){v=s
u=B.ah(r)
B.fM(A.aWP("The data provided in the message stream was not a valid MQTT Message, exception is "+B.k(v)),u)}else throw r}},
b9Z(d,e){var w,v,u,t
switch(d.a){case C.mN:w=new A.GQ()
w.a=d
v=new A.V9(C.aN,new A.dV())
v.is(e)
w.b=v
A.aQT()
u=new A.V8(v)
u.sCP(A.qk(e))
t=v.d
t===$&&B.a()
if(t.c){u.b=A.qk(e)
u.c=A.qk(e)}if(v.d.r){t=D.c.fI(A.qk(e))
u.d=t}if(v.d.f){v=D.c.fI(A.qk(e))
u.f=v}w.c=u
break
case C.mQ:w=new A.GP()
w.a=d
w.Sh(e)
v=new A.aoU(C.aN,new A.dV())
v.is(e)
w.b=v
break
case C.j7:w=new A.uM()
w.a=d
w.Sh(e)
v=new A.Vi(w.a,C.aN,new A.dV())
v.hE()
v.is(e)
w.b=v
u=w.a
t=new A.Vf(u,v)
t.c=e.aIh(u.e-v.a)
w.c=t
break
case C.j8:w=new A.zc()
w.a=d
v=new A.Vd(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
break
case C.jb:w=new A.zd()
w.a=d
v=new A.Ve(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
break
case C.j9:w=new A.ze()
w.a=d
v=new A.Vg(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
break
case C.ja:w=new A.zf()
w.a=d
v=new A.Vh(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
break
case C.mR:w=new A.GW()
w.a=d
d.c=C.bH
v=new A.Vk(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
v=new A.Vj(v,d,B.o(x.T,x.n))
v.is(e)
w.c=v
break
case C.mS:w=new A.GV()
w.a=d
v=new A.aoZ(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
v=new A.aoY(v,d,B.b([],x.v))
v.is(e)
w.c=v
break
case C.yi:w=new A.Vl()
w.a=d
v=new A.ap4(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
v=new A.ap3(v,d,B.b([],x.s))
v.is(e)
w.c=v
break
case C.mO:w=new A.GX()
w.a=d
v=new A.ap2(C.aN,new A.dV())
v.hE()
v.nu(e)
w.b=v
break
case C.j5:w=new A.GT()
w.a=d
break
case C.j6:w=new A.GU()
w.a=d
break
case C.mP:w=new A.GR()
w.a=d
break
default:throw B.e(A.akr("The Message Type specified ("+d.k(0)+".messageType) is not a valid MQTT Message type or currently not supported."))}return w},
aXC(d){var w,v,u,t
for(w=B.l(d),v=new B.bN(d,d.gE(0),w.j("bN<aQ.E>")),w=w.j("aQ.E"),u="";v.v();u=t){t=v.d
if(t==null)t=w.a(t)
t=u+"<"+B.k(t)+">"}return u.charCodeAt(0)==0?u:u},
ba0(d){var w,v
try{w=D.am.ff(d.en(d))
return w}catch(v){return""}},
aXE(){var w=new A.GW(),v=new A.it(C.aR)
v.a=C.mR
w.a=v
v.c=C.bH
v=new A.Vk(C.aN,new A.dV())
v.hE()
w.b=v
w.c=new A.Vj(null,null,B.o(x.T,x.n))
return w},
aRi(d){var w=new A.WH(d)
w.SS(d,B.b([A.b24(),A.b23(),A.bjs()],x.x))
return w},
bbb(d){var w=d.a
if(D.c.p(w,"#")||D.c.p(w,"+"))throw B.e(B.ch("mqtt_client::PublicationTopic: Cannot publish to a topic that contains MQTT topic wildcards (# or +)"))},
aRA(){var w=x.y
return new A.AB(B.b([],w),B.b([],x.p),B.b([],w),C.mT,A.aRB("rawtopic"),new A.QZ(x.Q))},
aRB(d){var w=new A.YN(d)
w.SS(d,B.b([A.b24(),A.b23(),A.bju(),A.bjt()],x.x))
return w},
bcu(d){var w=d.a
if(D.c.p(w,"#")&&!D.c.oU(w,"#"))throw B.e(B.ch("mqtt_client::SubscriptionTopic: The rawTopic wildcard # can only be present at the end of a topic"))
if(w.length>1&&D.c.oU(w,"#")&&!D.c.oU(w,"/#"))throw B.e(B.ch("mqtt_client::SubscriptionTopic: Topics using the # wildcard longer than 1 character must be immediately preceeded by a the rawTopic separator /"))},
bct(d){var w=d.b
w===$&&B.a()
if(D.b.es(w,new A.axq()))throw B.e(B.ch("mqtt_client::SubscriptionTopic: rawTopic Fragment contains a wildcard but is more than one character long"))},
bd7(d){var w=d.a.length
if(w>65535)throw B.e(B.ch("mqtt_client::Topic: The length of the supplied rawTopic ("+w+") is longer than the maximum allowable (65535)"))},
bd8(d){if(d.a.length===0)throw B.e(B.ch("mqtt_client::Topic: rawTopic must contain at least one character"))},
ql(d,e){d.jD(new A.dV().ln(e))},
qk(d){var w,v=d.nt(2)
if(v.b<2)B.S(B.ch("mqtt_client::MQTTEncoding: Length byte array must comprise 2 bytes"))
w=d.nt((v.ga2(v)<<8>>>0)+v.i(0,1))
return D.dR.bL(w.en(w))},
az(d,e){},
ap5(d){switch(d){case 0:return C.aR
case 1:return C.bH
case 2:return C.eA
case 128:return C.mT
default:return C.S4}},
GS:function GS(d,e){this.a=d
this.b=e},
za:function za(d,e){this.a=d
this.b=e},
Va:function Va(){},
Vb:function Vb(){},
Vc:function Vc(){var _=this
_.a=$
_.b=0
_.f=_.e=_.d=_.c=null
_.w=_.r=0
_.x=null
_.y=$
_.z=!1
_.as=_.Q=0},
dV:function dV(){},
Rn:function Rn(){this.a=$},
RH:function RH(){this.a=$},
U3:function U3(){this.a=$},
Uc:function Uc(){this.a=$},
Ud:function Ud(){this.a=$},
Ue:function Ue(){this.a=$},
Vy:function Vy(){this.a=$},
V7:function V7(d){var _=this
_.c=_.b=_.a=!1
_.d=d
_.r=_.f=_.e=!1},
GQ:function GQ(){this.b=null
this.c=$
this.a=null},
V8:function V8(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.e=""
_.f=null},
ml:function ml(d,e){this.a=d
this.b=e},
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
GP:function GP(){this.b=$
this.a=null},
aoU:function aoU(d,e){var _=this
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
GR:function GR(){this.a=null},
it:function it(d){var _=this
_.a=null
_.b=!1
_.c=d
_.d=!1
_.e=0},
dA:function dA(){},
fj:function fj(d,e){this.a=d
this.b=e},
aoV:function aoV(){},
ap6:function ap6(){},
GT:function GT(){this.a=null},
GU:function GU(){this.a=null},
uM:function uM(){this.b=null
this.c=$
this.a=null},
Vf:function Vf(d,e){this.a=d
this.b=e
this.c=$},
Vi:function Vi(d,e,f){var _=this
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
zc:function zc(){this.b=$
this.a=null},
Vd:function Vd(d,e){var _=this
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
Ve:function Ve(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
ze:function ze(){this.b=$
this.a=null},
Vg:function Vg(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
zf:function zf(){this.b=$
this.a=null},
Vh:function Vh(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GW:function GW(){var _=this
_.b=null
_.c=$
_.a=_.d=null},
Vj:function Vj(d,e,f){this.a=d
this.b=e
this.c=f},
ap1:function ap1(d){this.a=d},
ap_:function ap_(d,e){this.a=d
this.b=e},
ap0:function ap0(d){this.a=d},
Vk:function Vk(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GV:function GV(){this.b=null
this.c=$
this.a=null},
aoY:function aoY(d,e,f){this.a=d
this.b=e
this.c=f},
aoZ:function aoZ(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Vl:function Vl(){this.b=null
this.c=$
this.a=null},
ap3:function ap3(d,e,f){this.a=d
this.b=e
this.c=f},
ap4:function ap4(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GX:function GX(){this.b=$
this.a=null},
ap2:function ap2(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
GO:function GO(){},
jY:function jY(d,e,f){this.a=d
this.b=e
this.c=f},
z5:function z5(d){this.a=d},
xL:function xL(d){this.a=d},
qh:function qh(d,e){this.a=d
this.b=e},
xc:function xc(){},
A5:function A5(d){this.a=d},
y2:function y2(){},
y1:function y1(){},
ao2:function ao2(){this.a=0},
kR:function kR(d,e){this.a=d
this.b=e},
o3:function o3(d,e){this.b=d
this.$ti=e},
WH:function WH(d){this.a=d
this.b=$},
WI:function WI(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=!1
_.x=j
_.y=k},
AB:function AB(d,e,f,g,h,i){var _=this
_.b=null
_.c=!1
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i},
axr:function axr(){},
axs:function axs(){},
YN:function YN(d){this.a=d
this.b=$},
axq:function axq(){},
YO:function YO(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.x=_.w=_.r=null
_.y=!0
_.z=i
_.Q=j},
oH:function oH(){},
z9:function z9(d){this.a=d
this.b=0},
aoT:function aoT(){this.a=null},
V6:function V6(d){var _=this
_.a=d
_.c=_.b=$
_.d=!1},
QZ:function QZ(d){this.$ti=d},
VE:function VE(){},
DT:function DT(){},
AT:function AT(){},
a2K:function a2K(){},
fD:function fD(d,e){this.a=d
this.b=e}},C
J=c[1]
B=c[0]
D=c[2]
E=c[13]
A=a.updateHolder(c[7],A)
C=c[22]
A.agv.prototype={
r6(d){var w,v=this.a,u=B.l(v)
if(B.cy(d)===C.a48)return d.j("c6<0>").a(new B.cr(v,u.j("cr<1>")))
else{u=u.j("cr<1>")
w=u.j("OO<c6.T>")
return new B.DS(new B.OO(new A.agw(d),new B.cr(v,u),w),w.j("@<c6.T>").aE(d).j("DS<1,2>"))}}}
A.ja.prototype={
gEE(){return this.f},
gaF3(){return this.r},
Eu(d){return this.aEj(d)},
aEj(a0){var w=0,v=B.K(x.H),u,t=2,s=[],r=[],q=this,p,o,n,m,l,k,j,i,h,g,f,e,d
var $async$Eu=B.G(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:if(q.f||q.r){w=1
break}q.r=!0
D.b.M(q.e)
if(!q.d)q.aI()
l="flutter_"+a0+"_"+Date.now()
k="inbody/users/"+a0
p=k+"/data"
o=k+"/status"
k=q.b
if(k==null){j=new A.aoF("wss://broker.emqx.io/mqtt",l,new A.jY(C.cg,C.cz,C.ez))
j.b=8084
j.z=C.Pt
q.b=j
k=j}k.at=20
i=A.aXz()
k=i.c
k===$&&B.a()
k.sCP(l)
k=i.b.d
k===$&&B.a()
k.b=!0
k.c=!0
h=i.c
h.b=o
h.c="offline"
k.d=C.bH
k.e=!0
q.b.sMD(i)
k=q.b
k.cx=new A.aoW(q,a0)
t=4
w=7
return B.F(k.CT(),$async$Eu)
case 7:q.f=!0
k=q.b
h=p
if(k.ga1X().a!==C.bZ){g=k.y
B.S(A.aVe(g==null?null:g.cy.a))}k=k.Q
if(k.aJK(h)==null)k.a2i(h,C.bH)
B.k(p)
f=new A.aoT()
f.a=new A.fD(new Uint8Array(0),0)
n=f
n.awN("online")
k=q.b
k.toString
k.aHS(o,C.bH,n.a,!0)
k=q.c
if(k!=null)k.aB()
k=q.b.Q
if(k==null)k=null
else{k=k.Q
k=x.P.a(new B.cr(k,B.l(k).j("cr<1>")))}q.c=k.e7(new A.aoX(q,a0))
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
return B.J($async$Eu,v)},
B3(d,e){return this.ami(d,e)},
ami(d,e){var w=0,v=B.K(x.H),u=1,t=[],s=this,r,q,p,o,n
var $async$B3=B.G(function(f,g){if(f===1){t.push(g)
w=u}for(;;)switch(w){case 0:u=3
r=D.e4.a2p(d,null)
q=E.aWL("mqtt_"+Date.now(),r)
D.b.e4(s.e,0,q)
if(!s.d)s.aI()
w=6
return B.F(s.a.Co(e,q),$async$B3)
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
return B.J($async$B3,v)},
aAG(){var w=this,v=w.c
if(v!=null)v.aB()
w.c=null
v=w.b
if(v!=null)v.IB(!1)
w.f=!1
if(!w.d)w.aI()},
m(){var w,v=this
v.d=!0
w=v.c
if(w!=null)w.aB()
w=v.b
if(w!=null)w.IB(!1)
v.dG()},
$iac:1}
A.a3x.prototype={}
A.V5.prototype={
pb(d){var w,v,u,t,s,r,q,p,o,n=this,m=y.a
A.az("MqttBrowserConnection::_onData",!1)
u=J.dG(d,0,null)
if(u.length===0){A.az("MqttBrowserConnection::_ondata - Error - 0 byte message",!1)
return}t=n.d
t===$&&B.a()
t.a.O(0,u)
for(t=x.L,s=n.f;r=n.d,r.aF5();){w=!0
v=null
try{v=A.ba_(r)}catch(q){if(t.b(B.a_(q))){A.az("MqttBrowserConnection::_ondata - message is not yet valid, waiting for more data ...",!1)
w=!1}else throw q}if(!w){n.d.b=0
return}if(w){r=n.d
p=r.b
o=r.a
if(p<o.b){B.dB(0,p,o.gE(0),null,null)
if(p>0)o.I0(o,0,p)}else o.sE(0,0)
r.b=0
A.az("MqttBrowserConnection::_onData - message received ",v)
if(v.a.a===C.mQ){r=v
p=s.a
if((p.c&4)===0){if(!p.gmH())B.S(p.mz())
p.lF(new A.xL(r))}else A.az(m,!1)}else{r=v
p=s.a
if((p.c&4)===0){if(!p.gmH())B.S(p.mz())
p.lF(new A.z5(r))}else A.az(m,!1)}A.az("MqttBrowserConnection::_onData - message available event fired",!1)}else A.az("MqttBrowserConnection::_onData - WARN - message available event not fired, event bus is closed",!1)}},
ZZ(){var w,v,u
this.vu()
A.az("MqttBrowserConnection::_startListening",!1)
try{this.aGQ()}catch(v){u=B.a_(v)
if(x.L.b(u)){w=u
A.az("MqttBrowserConnection::_startListening - exception raised "+B.k(w),!1)}else throw v}}}
A.aoG.prototype={}
A.aoH.prototype={
xi(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b_(new B.aa($.ag,x.w),x.l)
A.az("MqttBrowserWsConnection::connect - entered",!1)
w=null
try{w=B.kb(d)}catch(p){if(x.L.b(B.a_(p))){v=B.ah(p)
u="MqttBrowserWsConnection::connect - The URI supplied for the WS connection is not valid - "+d
B.fM(A.uR(u),v)}else throw p}if(w.gjH()!=="ws"&&w.gjH()!=="wss")throw B.e(A.uR("MqttBrowserWsConnection::connect - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.PL(e)
t=w.gq9()
A.az("MqttBrowserWsConnection::connect -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a0<1,i>")
m=B.T(new B.a0(m,new A.aoM(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.z9(new A.fD(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kk(s,"open",new A.aoN(o,k,j),!1,n)
o.b=B.kk(s,"close",new A.aoO(o,j),!1,n)
o.a=B.kk(s,"error",new A.aoP(o,j),!1,n)}catch(p){if(x.L.b(B.a_(p))){r=B.ah(p)
q="MqttBrowserWsConnection::connect - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fM(A.uR(q),r)}else throw p}A.az("MqttBrowserWsConnection::connect - connection is waiting",!1)
return j.a},
ayI(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.b_(new B.aa($.ag,x.w),x.l)
A.az("MqttBrowserWsConnection::connectAuto - entered",!1)
w=null
try{w=B.kb(d)}catch(p){if(x.L.b(B.a_(p))){v=B.ah(p)
u="MqttBrowserWsConnection::connectAuto - The URI supplied for the WS connection is not valid - "+d
B.fM(A.uR(u),v)}else throw p}if(w.gjH()!=="ws"&&w.gjH()!=="wss")throw B.e(A.uR("MqttBrowserWsConnection::connectAuto - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.PL(e)
t=w.gq9()
A.az("MqttBrowserWsConnection::connectAuto -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a0<1,i>")
m=B.T(new B.a0(m,new A.aoI(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.z9(new A.fD(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.kk(s,"open",new A.aoJ(o,k,j),!1,n)
o.b=B.kk(s,"close",new A.aoK(o,j),!1,n)
o.a=B.kk(s,"error",new A.aoL(o,j),!1,n)}catch(p){if(x.L.b(B.a_(p))){r=B.ah(p)
q="MqttBrowserWsConnection::connectAuto - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fM(A.uR(q),r)}else throw p}A.az("MqttBrowserWsConnection::connectAuto - connection is waiting",!1)
return j.a},
vu(){var w,v,u
for(w=this.b,v=w.length,u=0;u<w.length;w.length===v||(0,B.w)(w),++u)w[u].aB()
D.b.M(w)},
CQ(){var w=this.a
if(w!=null)w.close()},
aGQ(){var w,v=this,u=v.a
if(u==null)throw B.e(B.aB("webSocket is null"))
w=x.m
return B.b([B.kk(u,"close",new A.aoQ(v),!1,w),B.kk(u,"message",new A.aoR(v),!1,w),B.kk(u,"error",new A.aoS(v),!1,w)],x.d)}}
A.axv.prototype={
ui(d,e,f){return this.aEC(d,e,f)},
aEC(d,e,a0){var w=0,v=B.K(x.e),u,t=2,s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f
var $async$ui=B.G(function(a1,a2){if(a1===1){s.push(a2)
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
j.a=C.yh
j.b=C.cz
if(!r.f){i=new A.aoH(C.OM,B.b([],o),p)
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
return B.F(j.xi(d,e),$async$ui)
case 13:w=11
break
case 12:A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connectAuto",!1)
j=r.ay
j===$&&B.a()
w=14
return B.F(j.ayI(d,e),$async$ui)
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
r.kG(a0)
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - pre sleep, state = "+r.cy.k(0),!1)
j=r.Q
j===$&&B.a()
if(!j.d){j.b=new B.b_(new B.aa($.ag,n),m)
j.c=B.cf(B.e7(0,j.a,0),j.gav_())
j.d=!0}j=j.b
j===$&&B.a()
w=15
return B.F(j.a,$async$ui)
case 15:++k
A.az("SynchronousMqttBrowserConnectionHandler::internalConnect - post sleep, state = "+r.cy.k(0),!1)
if(r.cy.a!==C.bZ)if(!r.f)A.az("SynchronousMqttBrowserConnectionHandler::internalConnect failed, attempt "+k,!1)
j=r.cy.a!==C.bZ
case 4:if(j&&k<l){w=3
break}case 5:if(j)if(!r.f){A.az("SynchronousMqttBrowserConnectionHandler::internalConnect failed",!1)
q=r.cy.b
l="The maximum allowed connection attempts ({"+l
if(q===C.cz)throw B.e(A.uR(l+"}) were exceeded. The broker is not responding to the connection request message (Missing Connection Acknowledgement?"))
else throw B.e(A.uR(l+"}) were exceeded. The broker is not responding to the connection request message correctly The return code is "+B.k(q)))}A.az("SynchronousMqttBrowserConnectionHandler::internalConnect exited with state "+r.cy.k(0),!1)
r.cx=!0
u=r.cy
w=1
break
case 1:return B.I(u,v)
case 2:return B.H(s.at(-1),v)}})
return B.J($async$ui,v)}}
A.aoF.prototype={
CT(){var w=0,v=B.K(x.F),u,t=this,s,r,q
var $async$CT=B.G(function(d,e){if(d===1)return B.H(e,v)
for(;;)switch(w){case 0:t.d=$.aXy=!0
s=new A.agv(new B.eo(null,null,x.J))
t.k1=s
s.r6(x.u).e7(t.gaAJ())
r=t.k1
if(r!=null)r.r6(x.o).e7(t.gaAH())
r=t.k1
q=new A.axv(3,r,B.o(x.q,x.i),B.b([],x.B),new A.jY(C.cg,C.cz,C.ez))
q.Q=new A.V6(5000)
r.r6(x.h).e7(q.gaxn())
r.r6(x.W).e7(q.gaG3())
r.r6(x._).e7(q.gayG())
t.y=q
w=3
return B.F(t.aaF(null,null),$async$CT)
case 3:u=e
w=1
break
case 1:return B.I(u,v)}})
return B.J($async$CT,v)}}
A.GS.prototype={
H(){return"MqttDisconnectionOrigin."+this.b}}
A.za.prototype={
H(){return"MqttConnectionState."+this.b}}
A.Va.prototype={
P3(){var w=this
w.vu()
w.CQ()
w.a=null
if(w.e!=null){A.az("MqttConnectionBase::_onDone - calling disconnected callback",!1)
w.e.$0()}}}
A.Vb.prototype={
xj(d,e,f){return this.ayE(d,e,f)},
ayE(d,e,f){var w=0,v=B.K(x.e),u,t=2,s=[],r=this,q,p,o
var $async$xj=B.G(function(g,h){if(g===1){s.push(h)
w=t}for(;;)switch(w){case 0:r.r=d
r.w=e
A.az("MqttConnectionHandlerBase::connect - server "+d+", port "+e,!1)
r.x=f
t=4
w=7
return B.F(r.ui(d,e,f),$async$xj)
case 7:q=r.cy
u=q
w=1
break
t=2
w=6
break
case 4:t=3
o=s.pop()
if(x.L.b(B.a_(o))){r.cy.a=C.S_
throw o}else throw o
w=6
break
case 3:w=2
break
case 6:case 1:return B.I(u,v)
case 2:return B.H(s.at(-1),v)}})
return B.J($async$xj,v)},
CC(d){return this.axo(d)},
axo(d){var w=0,v=B.K(x.H),u,t=this,s,r
var $async$CC=B.G(function(e,f){if(e===1)return B.H(f,v)
for(;;)switch(w){case 0:A.az("MqttConnectionHandlerBase::autoReconnect entered",!1)
s=t.f
if(s){w=1
break}t.f=!0
s=t.ay
s===$&&B.a()
s.vu()
s.CQ()
s.a=null
t.ay.e=null
A.az("MqttConnectionHandlerBase::autoReconnect - attempting reconnection",!1)
s=t.r
s.toString
r=t.w
r.toString
w=3
return B.F(t.xj(s,r,t.x),$async$CC)
case 3:r=f
t.cy=r
t.f=!1
s=t.as
if(r.a===C.bZ){t.ay.e=t.b
s.toString
A.zb(s,new A.A5(!0))
A.az("MqttConnectionHandlerBase::autoReconnect - auto reconnect complete",!1)}else{A.az("MqttConnectionHandlerBase::autoReconnect - auto reconnect failed - re trying",!1)
s.toString
A.zb(s,new A.xc())}case 1:return B.I(u,v)}})
return B.J($async$CC,v)},
kG(d){var w,v,u,t,s
A.az("MqttConnectionHandlerBase::sendMessage",!1)
w=this.cy.a
if(w===C.bZ||w===C.yh){v=new A.z9(new A.fD(new Uint8Array(0),0))
d.i6(v)
w=v.a.b
if(0<=w)v.b=0
else v.b=w
A.az("MqttConnectionHandlerBase::sendMessage = message is "+d.k(0),!1)
w=this.ay
w===$&&B.a()
u=J.rY(D.l.gbc(v.nt(v.a.b).a),0,null)
w=w.a
if(w!=null){t=B.a6(u)
t.toString
w.send(t)}for(w=this.CW,t=w.length,s=0;s<w.length;w.length===t||(0,B.w)(w),++s)w[s].$1(d)}else A.az("MqttConnectionHandlerBase::sendMessage - not connected",!1)},
aG4(d){var w,v=d.a,u=v.a.a
A.az("MqttConnectionHandlerBase::messageAvailable - message type is "+B.k(u),!1)
u.toString
w=this.ch.i(0,u)
if(w!=null)w.$1(v)
else A.az("MqttConnectionHandlerBase::messageAvailable - WARN - no registered callback for this message type",!1)},
ayF(d){var w,v,u,t,s=this,r=y.B
A.az("MqttConnectionHandlerBase::_connectAckProcessor",!1)
try{w=x.N.a(d)
v=w.b
v===$&&B.a()
u=!0
if(v.f!==C.aN){v=w.b
v===$&&B.a()
if(v.f!==C.ye){v=w.b
v===$&&B.a()
if(v.f!==C.yd){v=w.b
v===$&&B.a()
if(v.f!==C.yg){v=w.b
v===$&&B.a()
v=v.f===C.yf}else v=u}else v=u}else v=u}else v=u
if(v){A.az("MqttConnectionHandlerBase::_connectAckProcessor connection rejected",!1)
v=s.cy
u=w.b
u===$&&B.a()
v.b=u.f
A.az(r,!1)
s.cy.a=C.cg}else{A.az("MqttConnectionHandlerBase:_connectAckProcessor - state = connected",!1)
v=s.cy
v.a=C.bZ
v.b=C.yc}}catch(t){if(x.L.b(B.a_(t))){A.az(r,!1)
s.cy.a=C.cg}else throw t}A.az("MqttConnectionHandlerBase:: cancelling connect timer",!1)
v=s.Q
v===$&&B.a()
if(v.d){u=v.c
u===$&&B.a()
u.aB()
v.d=!1
v=v.b
v===$&&B.a()
v.eu()}return!0},
ayH(d){var w=d.a
w.toString
this.ayF(w)}}
A.Vc.prototype={
aHE(){var w,v,u,t,s,r=this
A.az("MqttConnectionKeepAlive::pingRequired",!1)
if(r.z)return!1
else r.z=!0
w=!1
u=new A.GT()
t=new A.it(C.aR)
t.a=C.j5
u.a=t
v=u
t=r.y
t===$&&B.a()
if(t.cy.a===C.bZ){A.az("MqttConnectionKeepAlive::pingRequired - sending ping request",!1)
try{r.y.kG(v)
w=!0
r.as=Date.now()}catch(s){A.az("MqttConnectionKeepAlive::pingRequired - exception occurred",!1)}}else A.az("MqttConnectionKeepAlive::pingRequired - NOT sending ping - not connected",!1)
A.az("MqttConnectionKeepAlive::pingRequired - restarting ping timer",!1)
t=r.a
t===$&&B.a()
r.c=B.cf(B.e7(0,t,0),r.ga5O())
if(r.b!==0){t=r.d
if(t==null){A.az("MqttConnectionKeepAlive::pingRequired - starting disconnect timer",!1)
if(w)r.d=B.cf(B.e7(0,r.b,0),r.ga5n())
else r.a5m()}else{t=t.b
if(t==null)if(w){A.az("MqttConnectionKeepAlive::pingRequired - restarting disconnect timer",!1)
r.d=B.cf(B.e7(0,r.b,0),r.ga5n())}else r.a5m()
else A.az("MqttConnectionKeepAlive::pingRequired - disconnect timer is active, not restarting",!1)}}r.z=!1
return w},
aHD(d){var w,v=this
A.az("MqttConnectionKeepAlive::pingRequestReceived",!1)
if(v.z)return!1
else v.z=!0
d=new A.GU()
w=new A.it(C.aR)
w.a=C.j6
d.a=w
w=v.y
w===$&&B.a()
w.kG(d)
v.z=!1
return!0},
aHG(d){var w,v,u,t=this
A.az("MqttConnectionKeepAlive::pingResponseReceived",!1)
w=Date.now()-t.as
t.r=w
v=++t.Q
u=t.w
t.w=u+D.d.kJ(w-u,v)
w=t.d
if(w!=null)w.aB()
return!0},
aG6(d){return!0},
aGo(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.bZ){A.az("MqttConnectionKeepAlive::noPingResponseReceived - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.zb(w,new A.y2())
A.az("MqttConnectionKeepAlive::noPingResponseReceived - OK - disconnect event fired",!1)}else A.az("MqttConnectionKeepAlive::noPingResponseReceived - ERROR - disconnect event not fired, no event handler",!1)}else A.az("MqttConnectionKeepAlive::noPingResponseReceived - not disconnecting, not connected",!1)},
a5m(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.bZ){A.az("MqttConnectionKeepAlive::noMessageSent - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.zb(w,new A.y1())
A.az("MqttConnectionKeepAlive::noMessageSent - OK - disconnect event fired",!1)}else A.az("MqttConnectionKeepAlive::noMessageSent - ERROR - disconnect event not fired, no event handler",!1)}else A.az("MqttConnectionKeepAlive::noMessageSent - not disconnecting, not connected",!1)}}
A.dV.prototype={
ln(d){var w,v,u
A.b9W(d)
w=D.as.bL(d)
v=w.length
if(v>65535)throw B.e(B.ch("MqttUtf8Encoding::toUtf8 -  UTF8 string length is invalid, length is "+v))
u=new A.fD(new Uint8Array(0),0)
u.oq(v>>>8)
u.oq(v&255)
u.O(0,w)
return u}}
A.Rn.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.RH.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.U3.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.Uc.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.Ud.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.Ue.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.Vy.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibg:1}
A.V7.prototype={
ayJ(){var w=this,v=w.a?1:0,u=w.b?1:0,t=w.c?1:0,s=w.d,r=w.e?1:0,q=w.f?1:0,p=w.r?1:0
return(v|u<<1|t<<2|s.a<<3|r<<5|q<<6|p<<7)>>>0},
k(d){var w=this
return"Connect Flags: Reserved1="+w.a+", CleanStart="+w.b+", WillFlag="+w.c+", WillQos="+w.d.k(0)+", WillRetain="+w.e+", PasswordFlag="+w.f+", UserNameFlag="+w.r}}
A.GQ.prototype={
a1n(d,e){return this},
i6(d){var w,v,u,t,s,r,q,p=this,o=p.a
o.toString
w=new A.dV().ln(p.b.b).b
v=p.c
v===$&&B.a()
u=new A.dV()
t=u.ln(v.e).b
s=v.a
r=s.d
r===$&&B.a()
if(r.c){r=v.b
r.toString
r=u.ln(r).b
q=v.c
q.toString
t=t+r+u.ln(q).b}if(s.d.r){r=v.d
r.toString
t+=u.ln(r).b}if(s.d.f){v=v.f
v.toString
t+=u.ln(v).b}o.kF(w+1+1+2+t,d)
o=p.b
A.ql(d,o.b)
d.nD(o.c)
v=o.d
v===$&&B.a()
d.nD(v.ayJ())
d.mq(o.e)
o=p.c
A.ql(d,o.e)
v=o.a
s=v.d
s===$&&B.a()
if(s.c){s=o.b
s.toString
A.ql(d,s)
s=o.c
s.toString
A.ql(d,s)}if(v.d.r){s=o.d
s.toString
A.ql(d,s)}if(v.d.f){o=o.f
o.toString
A.ql(d,o)}},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(y.h+u.e+"\n")
return u.charCodeAt(0)==0?u:u}}
A.V8.prototype={
sCP(d){var w,v=d.length
if(v>65535){w=new A.Rn()
w.a="mqtt-client::ClientIdentifierException: Client id "+d+" is too long at "+v+", Maximum ClientIdentifier length is 65535"
throw B.e(w)}this.e=d},
k(d){return y.h+this.e}}
A.ml.prototype={
H(){return"MqttConnectReturnCode."+this.b}}
A.V9.prototype={
is(d){var w=this
w.aIi(d)
w.aIj(d)
w.aIa(d)
w.aIf(d)},
k(d){var w=this,v=w.b,u=w.c,t=w.d
t===$&&B.a()
return"Connect Variable Header: ProtocolName="+v+", ProtocolVersion="+u+", ConnectFlags="+t.k(0)+", KeepAlive="+w.e}}
A.GP.prototype={
i6(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kF(2,d)
w=this.b
if(w.y)d.nD(1)
else d.nD(0)
d.nD(w.f.a)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.t+v.y+"}, ReturnCode={"+v.f.k(0)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.aoU.prototype={
is(d){d.h0()
this.aIk(d)},
k(d){return y.t+this.y+"}, ReturnCode={"+this.f.k(0)+"}"}}
A.GR.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.it.prototype={
kF(d,e){var w,v,u,t,s,r=this
r.e=d
w=new A.fD(new Uint8Array(0),0)
v=r.a.a
u=r.b?1:0
t=r.c
s=r.d?1:0
w.oq((v<<4>>>0)+(u<<3>>>0)+(t.a<<1>>>0)+s)
w.O(0,r.a8_())
e.jD(w)},
is(d){var w,v,u,t,s,r=this,q="The header being processed contained an invalid size byte pattern. Message size must take a most 4 bytes, and the last byte must have bit 8 set to 0."
if(d.a.b<2){d.b=0
throw B.e(A.akr("The supplied header is invalid. Header must be at least 2 bytes long."))}u=d.h0()
r.d=(u&1)===1
r.c=A.ap5(u>>>1&3)
r.b=(u>>>3&1)===1
r.a=C.O8[u>>>4&15]
try{r.e=A.b9X(A.b9Y(d))}catch(t){s=B.a_(t)
if(x.L.b(s)){w=B.ah(t)
B.fM(A.akr(q),w)}else if(x.C.b(s)){v=B.ah(t)
B.fM(A.akr(q),v)}else throw t}},
a8_(){var w,v,u=new A.fD(new Uint8Array(0),0),t=this.e
do{w=D.d.aV(t,128)
t=D.d.bQ(t,128)
v=t>0
u.oq(v?(w|128)>>>0:w)}while(v)
return u},
k(d){var w=this
return"Header: MessageType = "+B.k(w.a)+", Duplicate = "+w.b+", Retain = "+w.d+", Qos = "+w.c.k(0)+", Size = "+w.e}}
A.dA.prototype={
i6(d){this.a.kF(0,d)},
is(d){return},
k(d){var w="MQTTMessage of type "+(J.bb(this.a.a)+"\n")+(J.bb(this.a)+"\n")
return w.charCodeAt(0)==0?w:w}}
A.fj.prototype={
H(){return"MqttMessageType."+this.b}}
A.aoV.prototype={}
A.ap6.prototype={
hE(){this.b="MQIsdp"
this.c=3
this.d=new A.V7(C.aR)},
aIi(d){var w=A.qk(d)
this.b=w
this.a=this.a+(w.length+2)},
aIj(d){this.c=d.h0();++this.a},
aIf(d){this.e=d.a67()
this.a+=2},
aIk(d){this.f=C.Ny[d.h0()];++this.a},
aIl(d){var w=A.qk(d)
this.r=w
this.a=w.length+2},
nu(d){this.w=d.a67()
this.a+=2},
aIa(d){var w=new A.V7(C.aR),v=d.h0()
w.a=(v&1)===1
w.b=(v&2)===2
w.c=(v&4)===4
w.d=A.ap5(D.d.aG(v,3)&3)
w.e=(v&32)===32
w.f=(v&64)===64
w.r=(v&128)===128
this.d=w;++this.a},
gE(d){return this.a}}
A.GT.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.GU.prototype={
k(d){var w=this.iD(0)
return w.charCodeAt(0)==0?w:w}}
A.uM.prototype={
i6(d){var w,v,u=this,t=u.b,s=new A.dV().ln(t.r).b
t=t.y.c
if(t===C.bH||t===C.eA)s+=2
t=u.c
t===$&&B.a()
t=t.c
t===$&&B.a()
w=t.b
u.a.kF(s+w,d)
t=u.b
A.ql(d,t.r)
v=t.y.c
if(v===C.bH||v===C.eA){t=t.w
t.toString
d.mq(t)}t=u.c.c
t===$&&B.a()
d.jD(t)},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=u.c
u===$&&B.a()
u=w+(v+"\n")+("Payload: {"+u.b+" bytes={"+A.aXC(u)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.Vf.prototype={
k(d){var w=this.c
w===$&&B.a()
return"Payload: {"+w.b+" bytes={"+A.aXC(w)}}
A.Vi.prototype={
is(d){var w
this.aIl(d)
w=this.y.c
if(w===C.bH||w===C.eA)this.nu(d)},
k(d){return"Publish Variable Header: TopicName={"+this.r+"}, MessageIdentifier={"+B.k(this.w)+"}, VH Length={"+this.a+"}"}}
A.zc.prototype={
i6(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kF(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.p+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Vd.prototype={
k(d){return y.p+B.k(this.w)+"}"}}
A.zd.prototype={
i6(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kF(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.w+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Ve.prototype={
k(d){return y.w+B.k(this.w)+"}"}}
A.ze.prototype={
i6(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kF(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.g+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Vg.prototype={
k(d){return y.g+B.k(this.w)+"}"}}
A.zf.prototype={
i6(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kF(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.i+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Vh.prototype={
k(d){return y.i+B.k(this.w)+"}"}}
A.GW.prototype={
i6(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kF(2+w.GB(),d)
w=v.b.w
w.toString
d.mq(w)
v.c.i6(d)},
aJu(d){var w
this.d=d
w=this.c
w===$&&B.a()
w.c.h(0,d,C.aR)
return this},
axa(d){var w=this,v=w.c
v===$&&B.a()
if(v.c.G(w.d))w.c.c.h(0,w.d,d)
return w},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.Vj.prototype={
i6(d){this.c.ak(0,new A.ap1(d))},
is(d){var w,v,u,t=this.b.e-this.a.a
for(w=this.c,v=0;v<t;){u=A.qk(d)
v+=u.length+3
w.h(0,u,A.ap5(d.h0()))}},
GB(){var w={}
w.a=0
this.c.ak(0,new A.ap_(w,new A.dV()))
return w.a},
k(d){var w=new B.cL(""),v=this.c
w.a="Payload: Subscription [{"+v.a+"}]\n"
v.ak(0,new A.ap0(w))
v=w.a
return v.charCodeAt(0)==0?v:v}}
A.Vk.prototype={
k(d){return"Subscribe Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.GV.prototype={
i6(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kF(2+w.c.length,d)
w=v.b.w
w.toString
d.mq(w)
v.c.i6(d)},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.aoY.prototype={
i6(d){var w,v,u
for(w=this.c,v=w.length,u=0;u<w.length;w.length===v||(0,B.w)(w),++u)d.nD(w[u].a)},
is(d){var w,v,u=this.b.e-this.a.a
for(w=this.c,v=0;v<u;){++v
w.push(A.ap5(d.h0()))}},
k(d){var w,v=this.c,u=v.length,t="Payload: Qos grants [{"+u+"}]\n"
for(w=0;w<v.length;v.length===u||(0,B.w)(v),++w)t+="{{ Grant={"+v[w].k(0)+"} }}\n"
return t.charCodeAt(0)==0?t:t}}
A.aoZ.prototype={
k(d){return"SubscribeAck Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Vl.prototype={
i6(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kF(2+w.GB(),d)
w=v.b.w
w.toString
d.mq(w)
D.b.ak(v.c.c,d.gaK9())},
k(d){var w=this.iD(0),v=J.bb(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.ap3.prototype={
is(d){var w,v,u,t=this.b.e-this.a.a
for(w=this.c,v=0;v<t;){u=A.qk(d)
v+=u.length+2
w.push(u)}},
GB(){var w,v,u,t,s=new A.dV()
for(w=this.c,v=w.length,u=0,t=0;t<w.length;w.length===v||(0,B.w)(w),++t)u+=s.ln(w[t]).b
return u},
k(d){var w,v=this.c,u=v.length,t="Payload: Unsubscription [{"+u+"}]\n"
for(w=0;w<u;++w)t+="{{ Topic={"+v[w]+"}}\n"
return t.charCodeAt(0)==0?t:t}}
A.ap4.prototype={
k(d){return"Unsubscribe VariableHeader Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.GX.prototype={
i6(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kF(2,d)
w=this.b.w
w.toString
d.mq(w)},
k(d){var w=this.iD(0),v=this.b
v===$&&B.a()
v=w+(y.k+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.ap2.prototype={
k(d){return y.k+B.k(this.w)+"}"}}
A.GO.prototype={
ga1X(){var w=this.y
return w!=null?w.cy:this.ch},
sMD(d){var w
this.CW=d
w=d.b
if(w!=null)w.c=3
w=d.b
if(w!=null)w.b="MQIsdp"},
xi(d,e){return this.ayD(d,e)},
ayD(d,e){var w=0,v=B.K(x.F),u,t=this,s,r,q,p,o,n,m
var $async$xi=B.G(function(f,g){if(f===1)return B.H(g,v)
for(;;)switch(w){case 0:if(!t.d){s=new A.U3()
s.a="mqtt-client::ClientIncorrectInstantiationException: Incorrect instantiation, do notinstantiate MqttClient directly, use MqttServerClient or MqttBrowserClient"
throw B.e(s)}$.aXA=$.aXA+1
s=t.CW
if(s!=null)s.a1n(d,e)
r=t.y
if(r==null)throw B.e(B.aB("connectionHandler is null"))
s=t.z
if(s!=null)r.at=s
r.b=t.gaEE()
r.e=r.d=r.c=r.a=null
A.az("MqttClient::connect - Connection timeout period is 5000 milliseconds",!1)
s=t.k1
q=$.b3z()
p=x.S
o=x.c
s=new A.WI(q,B.o(p,o),B.o(p,o),B.o(x.I,o),B.o(x.E,x.K),r,new B.eo(null,null,x.U),s)
o=r.ch
o.h(0,C.j8,s.gaDe())
o.h(0,C.j7,s.gaDc())
o.h(0,C.jb,s.gaDg())
o.h(0,C.ja,s.gaDk())
o.h(0,C.j9,s.gaDi())
t.ay=s
s.r=!1
s=t.k1
n=x.Z
q=new A.YO(q,B.o(p,n),B.o(p,n),B.o(p,n),r,s,new B.hm(null,null,x.M))
o.h(0,C.mS,q.gayz())
o.h(0,C.mO,q.gayB())
s.r6(x.b).e7(q.gaHT())
s.r6(x.k).e7(q.gasV())
t.Q=q
q.x=q.w=q.r=null
q.y=!0
s=t.at
if(s!==0){A.az("MqttClient::connect - keep alive is enabled with a value of "+s+" seconds",!1)
s=t.k1
q=t.at
p=new A.Vc()
p.y=r
p.x=s
p.a=q*1000
o.h(0,C.j5,p.gaHC())
o.h(0,C.j6,p.gaHF())
r.CW.push(p.gaG5())
p.c=B.cf(B.e7(0,p.a,0),p.ga5O())
A.az("MqttConnectionKeepAlive:: Initialised with a keep alive value of "+q+" seconds",!1)
A.az("MqttConnectionKeepAlive:: Disconnect on no ping response is disabled",!1)
t.as=p}else A.az("MqttClient::connect - keep alive is disabled",!1)
m=t.CW
if(m==null){s=A.aXz()
q=s.c
q===$&&B.a()
q.sCP(t.c)
q=s.b.d
q===$&&B.a()
q.d=C.aR
m=s.a1n(d,e)
s=m.b.d
s===$&&B.a()
s.b=!0
t.sMD(m)}s=m.c
s===$&&B.a()
if(s.e.length===0)s.sCP(t.c)
s=m.b
if(s!=null)s.e=t.at
t.sMD(m)
u=r.xj(t.a,t.b,m)
w=1
break
case 1:return B.I(u,v)}})
return B.J($async$xi,v)},
aHS(d,e,f,g){var w,v,u,t,s,r,q,p,o,n,m=null,l=this.y,k=l==null
if((k?m:l.cy.a)!==C.bZ)throw B.e(A.aVe(k?m:l.cy.a))
try{w=A.aRi(d)
l=this.ay
l.toString
k=w.a
A.az("PublishingManager::publish - entered with topic "+k,!1)
t=l.a.Gv()
s=new A.uM()
r=new A.it(C.aR)
r.a=C.j7
s.a=r
q=new A.Vi(r,C.aN,new A.dV())
q.hE()
s.b=q
p=new A.Vf(m,m)
o=new A.fD(new Uint8Array(0),0)
p.c=o
s.c=p
q.r=k
q.w=t
r.c=e
o.O(0,f)
r.d=!0
if(e===C.bH||e===C.eA)l.b.h(0,t,s)
l.f.kG(s)
return t}catch(n){l=B.a_(n)
if(x.L.b(l)){v=l
u=B.ah(n)
l=new A.Ue()
l.a="mqtt-client::InvalidTopicException: Topic "+d+" is "+J.bb(v)
B.fM(l,u)}else throw n}},
aAK(d){var w
A.az("MqttClient::_disconnectOnNoPingResponse - disconnecting, no ping request response for 0 seconds",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.P3()}this.Oo()},
aAI(d){var w
A.az("MqttClient::disconnectOnNoMessageSent - disconnecting, no message sent due to exception like socket exception",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.P3()}this.Oo()},
Oo(){var w=this.y
if(w==null){A.az("MqttClient::internalDisconnect - not invoking disconnect, no connection handler",!1)
return}if(w.cx)this.IB(!0)},
IB(d){var w,v,u,t,s=this
if(!d){w=s.y
if(w!=null){A.az("MqttConnectionHandlerBase::disconnect - entered",!1)
if(w.cy.a===C.bZ){v=new A.GR()
u=new A.it(C.aR)
u.a=C.mP
v.a=u
w.kG(v)}A.az(y.B,!1)
w.cy.a=C.cg}w=s.y
if(w!=null){v=w.ay
v===$&&B.a()
v.vu()
w.ay.CQ()}t=C.S1}else t=C.S0
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
v=s.ga1X().b
w.b=v
s.y=null
v=s.k1
if(v!=null)v.a.b1()
s.k1=null
w.a=C.cg
w.c=t
w=s.cx
if(w!=null)w.$0()}}
A.jY.prototype={
k(d){return"Connection status is "+this.a.H().split(".")[1]+" with return code of "+J.bb(this.b).split(".")[1]+" and a disconnection origin of "+this.c.H().split(".")[1]}}
A.z5.prototype={}
A.xL.prototype={}
A.qh.prototype={}
A.xc.prototype={}
A.A5.prototype={}
A.y2.prototype={}
A.y1.prototype={}
A.ao2.prototype={
Gv(){var w=++this.a
return w===32768?this.a=1:w}}
A.kR.prototype={
H(){return"MqttQos."+this.b}}
A.o3.prototype={}
A.WH.prototype={}
A.WI.prototype={
aDf(d){var w,v=x.z.a(d).b
v===$&&B.a()
w=v.w
A.az("PublishingManager::handlePublishAcknowledgement for message id "+B.k(w),!1)
v=this.b
if(v.G(w)){w.toString
this.XB(v.i(0,w))
v.F(0,w)}return!0},
aDd(d){var w,v,u,t,s,r,q,p,o,n,m=this
x.c.a(d)
w=d
v=!0
try{u=A.aRi(w.b.r)
A.az("PublishingManager::handlePublish - publish received from broker with topic "+B.k(u),!1)
if(w.a.c===C.aR){q=m.y
if(q!=null)A.zb(q,new A.qh(d,u))}else if(w.a.c===C.bH){q=m.y
if(q!=null)A.zb(q,new A.qh(d,u))
t=w.b.w
p=new A.zc()
q=new A.it(C.aR)
q.a=C.j8
p.a=q
q=new A.Vd(C.aN,new A.dV())
q.hE()
p.b=q
q.w=t
s=p
m.f.kG(s)}else if(w.a.c===C.eA){q=m.d
if(!q.G(w.b.w))q.h(0,w.b.w,w)
o=new A.ze()
q=new A.it(C.aR)
q.a=C.j9
o.a=q
q=new A.Vg(C.aN,new A.dV())
q.hE()
o.b=q
q.w=w.b.w
r=o
m.f.kG(r)}}catch(n){if(x.L.b(B.a_(n)))v=!1
else throw n}return v},
aDl(d){var w,v,u,t,s,r,q,p=x.G.a(d).b
p===$&&B.a()
w=p.w
A.az("PublishingManager::handlePublishRelease - for message identifier "+B.k(w),!1)
v=!0
try{u=this.d.F(0,w)
if(u!=null){t=A.aRi(u.b.r)
p=this.y
if(p!=null)A.zb(p,new A.qh(u,t))
r=new A.zd()
p=new A.it(C.aR)
p.a=C.jb
r.a=p
p=new A.Ve(C.aN,new A.dV())
p.hE()
r.b=p
p.w=u.b.w
s=r
this.f.kG(s)}}catch(q){if(x.L.b(B.a_(q)))v=!1
else throw q}return v},
aDh(d){var w,v=x.a.a(d).b
v===$&&B.a()
w=v.w
A.az("PublishingManager::handlePublishComplete - for message identifier "+B.k(w),!1)
this.XB(this.b.F(0,w))
return!0},
aDj(d){var w,v,u
x.R.a(d)
w=d.b
w===$&&B.a()
v=w.w
A.az("PublishingManager::handlePublishReceived - for message identifier "+B.k(v),!1)
if(this.b.G(v)){u=new A.zf()
w=new A.it(C.aR)
w.a=C.ja
u.a=w
w.c=C.bH
w=new A.Vh(C.aN,new A.dV())
w.hE()
u.b=w
w.w=d.b.w
this.f.kG(u)}return!0},
XB(d){var w=this.x
if(w.d!=null&&d!=null){A.az("PublishingManager::_notifyPublish - adding message to published stream for topic "+d.b.r,!1)
A.aXD(w,d)}}}
A.AB.prototype={
glg(){return this.w},
grq(){var w=this.x
return w},
gxR(){var w=this.e,v=B.Z(w).j("bd<1>")
w=B.T(new B.bd(w,new A.axr(),v),v.j("A.E"))
return w},
gzS(){var w=this.e,v=B.Z(w).j("bd<1>")
w=B.T(new B.bd(w,new A.axs(),v),v.j("A.E"))
return w},
gA(d){var w=D.c.gA(this.grq().a),v=B.fA(this.glg()),u=this.c?519018:218159
return w+v+u},
aJO(d){var w,v,u=this
if(d.length!==u.gxR().length+u.gzS().length)return!1
for(w=0;w<u.gxR().length+u.gzS().length;++w)u.e[w].slg(d[w])
v=D.b.ga2(u.e).glg()
if(!u.c)u.w=v
return!0},
l(d,e){var w,v=this
if(e==null)return!1
if(v!==e)w=e instanceof A.AB&&B.p(v)===B.p(e)&&v.grq().a===e.grq().a&&v.glg()===e.glg()&&v.c===e.c&&v.b==e.b
else w=!0
return w},
k(d){var w=this,v="Subscription:: Batch: "+w.c+", MID: "+B.k(w.b)+", Topic: "+w.grq().a+", QoS: "+w.glg().k(0)+", Total Batch: "+(w.gxR().length+w.gzS().length)+"\n"
return v.charCodeAt(0)==0?v:v}}
A.YN.prototype={}
A.YO.prototype={
aJK(d){var w,v,u
for(w=this.b,w=new B.bB(w,w.r,w.e,B.l(w).j("bB<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}for(w=this.c,w=new B.bB(w,w.r,w.e,B.l(w).j("bB<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}return null},
a2i(d,e){var w,v,u,t,s,r,q,p
try{w=A.aRB(d)
v=this.a.Gv()
u=A.aRA()
u.x=w
r=u
if(!r.c)r.w=e
u.b=v
Date.now()
this.c.h(0,v,u)
r=A.aXE()
q=u.b
r.b.w=q
t=r.aJu(u.grq().a).axa(u.glg())
this.e.kG(t)
return u}catch(p){r=B.a_(p)
if(x.L.b(r)){s=r
A.az("SubscriptionsManager::createNewSubscription exception raised, text is "+B.k(s),!1)
return null}else throw p}},
aA2(d){var w,v,u,t,s,r,q,p,o,n,m,l
try{w=A.aRB(D.b.ga2(d).grq())
v=this.a.Gv()
u=A.aRA()
u.c=!0
u.x=w
u.e=d
u.r=d
u.b=v
Date.now()
this.c.h(0,v,u)
q=A.aXE()
q.b.w=v
t=q
for(p=0;!1;++p){s=d[p]
o=t
n=s.grq()
o.d=n
o=o.c
o===$&&B.a()
o.c.h(0,n,C.aR)
n=t
o=s.glg()
m=n.c
m===$&&B.a()
if(m.c.G(n.d))n.c.c.h(0,n.d,o)}this.e.kG(t)
return u}catch(l){o=B.a_(l)
if(x.L.b(o)){r=o
A.az("SubscriptionsManager::createNewBatchSubscription exception raised, text is "+B.k(r),!1)
return null}else throw l}},
aHU(d){A.aXD(this.Q,B.b([new A.o3(d.a,x.X)],x.f))},
ayA(d){var w,v,u,t
x.A.a(d)
w=d.b.w
w.toString
A.aRA()
v=this.c
if(v.G(w))u=v.i(0,w)
else{A.az("SubscriptionsManager::confirmSubscription Sub Ack received for non pending subscription",!1)
return!1}if(!u.c){t=d.c
t===$&&B.a()
t=t.c
if(t.length===0||D.b.ga2(t)===C.mT){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription failed for single subscription "+D.b.ga2(d.c.c).k(0),!1)
return!1}}else{t=d.c
t===$&&B.a()
if(!u.aJO(t.c)){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription failed to update qos grants for batch subscription, lengths differ","Requested: 0, Received: "+d.c.c.length)
return!1}if(d.c.c.length===0||u.gxR().length===u.gxR().length+u.gzS().length){v.F(0,w)
A.az("SubscriptionsManager::confirmSubscription all qos grants failed",!1)
return!1}}v.F(0,w)
this.b.h(0,w,u)
return!0},
ayC(d){var w,v=x.D.a(d).b
v===$&&B.a()
w=v.w
v=this.d
if(v.G(w)){v.i(0,w)
this.b.F(0,null)}A.az("SubscriptionsManager::confirmUnsubscribe subscription not found in pending unsubscriptions",!1)
return!0},
asW(d){var w,v,u,t,s,r,q,p=this
A.az("Subscriptionsmanager::_resubscribe - resubscribing from auto reconnect "+d.a,!1)
w=p.b
v=B.l(w).j("br<2>")
u=B.T(new B.br(w,v),v.j("A.E"))
v=p.c
t=B.l(v).j("br<2>")
s=B.T(new B.br(v,t),t.j("A.E"))
w.M(0)
v.M(0)
w=B.T(u,x.Z)
D.b.O(w,s)
v=w.length
r=0
for(;r<w.length;w.length===v||(0,B.w)(w),++r){q=w[r]
if(q.c)p.aA2(q.r)
else{t=q.x
p.a2i(t.a,q.glg())}}}}
A.oH.prototype={
gA(d){return D.c.gA(this.a)},
SS(d,e){var w,v
this.b=B.b(this.a.split("/"[0]),x.s)
for(w=e.length,v=0;v<e.length;e.length===w||(0,B.w)(e),++v)e[v].$1(this)},
l(d,e){if(e==null)return!1
if(this===e)return!0
return e instanceof A.oH&&this.a===e.a},
k(d){return this.a}}
A.z9.prototype={
gE(d){return this.a.b},
aF5(){if(this.a.b-this.b>0)return!0
return!1},
h0(){var w=this,v=w.a.i(0,w.b),u=w.b
if(u<=w.a.b-1)w.b=u+1
else return-1
return v},
a67(){return(this.h0()<<8>>>0)+this.h0()},
nt(d){var w,v,u,t,s=this,r=null,q=s.a,p=q.b
if(p<d||s.b+d>p)throw B.e(B.ch("mqtt_client::ByteBuffer::read: The buffer does not have enough bytes for the read operation length "+s.gE(0)+", count "+d+", position "+s.b+", buffer "+q.k(q)))
if($.aXy){w=new A.fD(new Uint8Array(0),0)
p=s.b
v=p+d
B.dB(p,v,q.gE(0),r,r)
w.O(0,B.hg(q,p,v,B.l(q).j("aQ.E")))
s.b+=d
u=new A.fD(new Uint8Array(0),0)
u.O(0,w)
return u}else{p=s.b+=d
v=new A.fD(new Uint8Array(0),0)
t=p-d
B.dB(t,p,q.gE(0),r,r)
v.O(0,B.hg(q,t,p,B.l(q).j("aQ.E")))
return v}},
aIh(d){var w,v,u,t=this,s=t.a,r=s.b
if(r<d||t.b+d>r)throw B.e(B.ch("mqtt_client::ByteBuffer::readPayload: The buffer does not have enough bytes for the read operation length "+t.gE(0)+", count "+d+", position "+t.b+", buffer "+s.k(s)))
if(d<=32767)return t.nt(d)
r=t.b
if(r!==0){s.FD(s,0,r)
s=t.b=0}else s=r
w=new A.fD(new Uint8Array(0),0)
r=t.a
v=r.b
if(v===d){t.b=v
s=new A.fD(new Uint8Array(0),0)
s.O(0,r)
return s}else{s+=d
B.dB(s,v,r.gE(0),null,null)
w.O(0,B.hg(r,s,v,B.l(r).j("aQ.E")).en(0))
r=t.a
r.FD(r,t.b+d,r.b)
u=new A.fD(new Uint8Array(0),0)
u.O(0,t.a)
t.a.sE(0,0)
t.a.O(0,w)
t.b=0
return u}},
nD(d){var w=this.a,v=w.b,u=this.b
if(v===u)w.oq(d)
else w.h(0,u,d);++this.b},
mq(d){this.nD(D.d.aG(d,8))
this.nD(d&255)},
jD(d){this.a.O(0,d)
this.b=this.a.b},
aKa(d){A.ql(this,d)},
k(d){var w,v=this.a
v=v.ga6(v)
if(!v){v=this.a
w=B.m6(v.en(v),"[","]")}else w="null or empty"
return w}}
A.aoT.prototype={
gE(d){return this.a.b},
awN(d){var w,v,u,t,s,r
for(w=new B.fJ(d),v=x.V,w=new B.bN(w,w.gE(0),v.j("bN<aQ.E>")),u=x.t,v=v.j("aQ.E");w.v();){t=w.d
if(t==null)t=v.a(t)
if(t<=255&&t>=0)this.a.oq(t)
else{s=new Uint16Array(B.b0(B.b([t],u)))
t=this.a
r=J.b5O(D.mV.gbc(s))
t.a_C(r,0,null)}}return this}}
A.V6.prototype={
av0(){this.d=!1
var w=this.b
w===$&&B.a()
w.eu()}}
A.QZ.prototype={}
A.VE.prototype={}
A.DT.prototype={}
A.AT.prototype={
gE(d){return this.b},
i(d,e){if(e>=this.b)throw B.e(B.U4(e,this,null,null,null))
return this.a[e]},
h(d,e,f){var w
if(e>=this.b)throw B.e(B.U4(e,this,null,null,null))
w=this.a
w.$flags&2&&B.a4(w)
w[e]=f},
sE(d,e){var w,v,u,t,s=this,r=s.b
if(e<r)for(w=s.a,v=w.$flags|0,u=e;u<r;++u){v&2&&B.a4(w)
w[u]=0}else{r=s.a.length
if(e>r){if(r===0)t=new Uint8Array(e)
else t=s.Lb(e)
D.l.bO(t,0,s.b,s.a)
s.a=t}}s.b=e},
oq(d){var w,v=this,u=v.b
if(u===v.a.length)v.a_D(u)
u=v.a
w=v.b++
u.$flags&2&&B.a4(u)
u[w]=d},
t(d,e){var w,v=this,u=v.b
if(u===v.a.length)v.a_D(u)
u=v.a
w=v.b++
u.$flags&2&&B.a4(u)
u[w]=e},
tA(d,e,f,g){B.f4(f,"start")
this.a_C(e,f,g)},
O(d,e){return this.tA(0,e,0,null)},
a_C(d,e,f){var w,v,u
if(x.j.b(d))f=J.aP(d)
if(f!=null){this.avc(this.b,d,e,f)
return}for(w=J.bt(d),v=0;w.v();){u=w.gN()
if(v>=e)this.oq(u);++v}if(v<e)throw B.e(B.aB("Too few elements"))},
avc(d,e,f,g){var w,v,u,t,s=this
if(x.j.b(e)){w=J.a9(e)
if(f>w.gE(e)||g>w.gE(e))throw B.e(B.aB("Too few elements"))}v=g-f
u=s.b+v
s.avb(u)
w=s.a
t=d+v
D.l.bA(w,t,s.b+v,w,d)
D.l.bA(s.a,d,t,e,f)
s.b=u},
avb(d){var w,v=this
if(d<=v.a.length)return
w=v.Lb(d)
D.l.bO(w,0,v.b,v.a)
v.a=w},
Lb(d){var w=this.a.length*2
if(d!=null&&w<d)w=d
else if(w<8)w=8
return new Uint8Array(w)},
a_D(d){var w=this.Lb(null)
D.l.bO(w,0,d,this.a)
this.a=w},
bA(d,e,f,g,h){var w=this.b
if(f>w)throw B.e(B.cm(f,0,w,null,null))
w=this.a
if(g instanceof A.fD)D.l.bA(w,e,f,g.a,h)
else D.l.bA(w,e,f,g,h)},
bO(d,e,f,g){return this.bA(0,e,f,g,0)}}
A.a2K.prototype={}
A.fD.prototype={}
var z=a.updateTypes(["D(dA?)","~(oH)","~()","~(i?,kR?)","D(aUK)","~(M<o3<dA>>)","~(xc)","~(z5)","~(xL)","D()","~(y2)","~(y1)","~(qh)","~(A5)","~(i)"])
A.agw.prototype={
$1(d){return this.a.b(d)},
$S:565}
A.aoW.prototype={
$0(){var w=this.a
w.f=!1
if(!w.d)w.aI()},
$S:0}
A.aoX.prototype={
$1(d){var w,v=x.c.a(J.c2(d,0).b),u=v.c
u===$&&B.a()
u=u.c
u===$&&B.a()
w=A.ba0(u)
this.a.B3(w,this.b)},
$S:z+5}
A.aoM.prototype={
$1(d){return d},
$S:52}
A.aoN.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
this.b.ZZ()
return this.c.eu()},
$S:2}
A.aoO.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eM(new A.jY(C.cg,C.cz,C.ez))},
$S:2}
A.aoP.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connect - websocket has erred",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eM(new A.jY(C.cg,C.cz,C.ez))},
$S:2}
A.aoI.prototype={
$1(d){return d},
$S:52}
A.aoJ.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
this.b.ZZ()
return this.c.eu()},
$S:2}
A.aoK.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eM(new A.jY(C.cg,C.cz,C.ez))},
$S:2}
A.aoL.prototype={
$1(d){var w,v
A.az("MqttBrowserWsConnection::connectAuto - websocket has errored",!1)
w=this.a
v=w.c
if(v!=null)v.aB()
v=w.b
if(v!=null)v.aB()
w=w.a
if(w!=null)w.aB()
return this.b.eM(new A.jY(C.cg,C.cz,C.ez))},
$S:2}
A.aoQ.prototype={
$1(d){A.az("MqttBrowserConnection::_startListening - websocket is closed",!1)
this.a.P3()},
$S:2}
A.aoR.prototype={
$1(d){this.a.pb(d.data)},
$S:2}
A.aoS.prototype={
$1(d){var w
A.az("MqttBrowserConnection::_startListening - websocket has errored",!1)
w=this.a
w.vu()
w.CQ()
w.a=null
if(w.e!=null){A.az("MqttConnectionBase::_onError - calling disconnected callback",!1)
w.e.$0()}},
$S:2}
A.ap1.prototype={
$2(d,e){var w=this.a
d.toString
A.ql(w,d)
w.nD(e.a)},
$S:z+3}
A.ap_.prototype={
$2(d,e){var w,v=this.a,u=v.a
d.toString
w=u+this.b.ln(d).b
v.a=w
v.a=w+1},
$S:z+3}
A.ap0.prototype={
$2(d,e){var w=this.a,v="{{ Topic={"+B.k(d)+"}, Qos={"+B.k(e)+"} }}\n"
w.a+=v},
$S:z+3}
A.axr.prototype={
$1(d){d.glg()
return!1},
$S:z+4}
A.axs.prototype={
$1(d){d.glg()
return!0},
$S:z+4}
A.axq.prototype={
$1(d){return(D.c.p(d,"#")||D.c.p(d,"+"))&&d.length>1},
$S:29};(function aliases(){var w=A.dA.prototype
w.Sh=w.is
w.iD=w.k
w=A.GO.prototype
w.aaF=w.xi})();(function installTearOffs(){var w=a._instance_0u,v=a._static_1,u=a._instance_1u
w(A.ja.prototype,"gdh","m",2)
v(A,"bjs","bbb",1)
v(A,"bju","bcu",1)
v(A,"bjt","bct",1)
v(A,"b23","bd7",1)
v(A,"b24","bd8",1)
var t
u(t=A.Vb.prototype,"gaxn","CC",6)
u(t,"gaG3","aG4",7)
u(t,"gayG","ayH",8)
w(t=A.Vc.prototype,"ga5O","aHE",9)
u(t,"gaHC","aHD",0)
u(t,"gaHF","aHG",0)
u(t,"gaG5","aG6",0)
w(t,"ga5n","aGo",2)
u(t=A.GO.prototype,"gaAJ","aAK",10)
u(t,"gaAH","aAI",11)
w(t,"gaEE","Oo",2)
u(t=A.WI.prototype,"gaDe","aDf",0)
u(t,"gaDc","aDd",0)
u(t,"gaDk","aDl",0)
u(t,"gaDg","aDh",0)
u(t,"gaDi","aDj",0)
u(t=A.YO.prototype,"gaHT","aHU",12)
u(t,"gayz","ayA",0)
u(t,"gayB","ayC",0)
u(t,"gasV","asW",13)
u(A.z9.prototype,"gaK9","aKa",14)
w(A.V6.prototype,"gav_","av0",2)})();(function inheritance(){var w=a.mixin,v=a.inheritMany,u=a.inherit
v(B.u,[A.agv,A.a3x,A.Va,A.Vb,A.GO,A.Vc,A.dV,A.Rn,A.RH,A.U3,A.Uc,A.Ud,A.Ue,A.Vy,A.V7,A.dA,A.aoV,A.ap6,A.it,A.jY,A.z5,A.xL,A.qh,A.xc,A.A5,A.y2,A.y1,A.ao2,A.DT,A.oH,A.WI,A.VE,A.YO,A.z9,A.aoT,A.V6,A.QZ])
v(B.eF,[A.agw,A.aoX,A.aoM,A.aoN,A.aoO,A.aoP,A.aoI,A.aoJ,A.aoK,A.aoL,A.aoQ,A.aoR,A.aoS,A.axr,A.axs,A.axq])
u(A.ja,A.a3x)
u(A.aoW,B.hF)
u(A.V5,A.Va)
u(A.aoG,A.Vb)
u(A.aoH,A.V5)
u(A.axv,A.aoG)
u(A.aoF,A.GO)
v(B.kj,[A.GS,A.za,A.ml,A.fj,A.kR])
v(A.dA,[A.GQ,A.GP,A.GR,A.GT,A.GU,A.uM,A.zc,A.zd,A.ze,A.zf,A.GW,A.GV,A.Vl,A.GX])
v(A.aoV,[A.V8,A.Vf,A.Vj,A.aoY,A.ap3])
v(A.ap6,[A.V9,A.aoU,A.Vi,A.Vd,A.Ve,A.Vg,A.Vh,A.Vk,A.aoZ,A.ap4,A.ap2])
v(B.i8,[A.ap1,A.ap_,A.ap0])
u(A.o3,A.DT)
v(A.oH,[A.WH,A.YN])
u(A.AB,A.VE)
u(A.AT,B.aQ)
u(A.a2K,A.AT)
u(A.fD,A.a2K)
w(A.a3x,B.aS)})()
B.jy(b.typeUniverse,JSON.parse('{"ja":{"aS":[],"ac":[]},"uM":{"dA":[]},"AB":{"VE":["DT"]},"Rn":{"bg":[]},"RH":{"bg":[]},"U3":{"bg":[]},"Uc":{"bg":[]},"Ud":{"bg":[]},"Ue":{"bg":[]},"Vy":{"bg":[]},"GQ":{"dA":[]},"GP":{"dA":[]},"GR":{"dA":[]},"GT":{"dA":[]},"GU":{"dA":[]},"zc":{"dA":[]},"zd":{"dA":[]},"ze":{"dA":[]},"zf":{"dA":[]},"GW":{"dA":[]},"GV":{"dA":[]},"Vl":{"dA":[]},"GX":{"dA":[]},"WH":{"oH":[]},"YN":{"oH":[]},"AT":{"aQ":["1"],"M":["1"],"aJ":["1"],"A":["1"]},"a2K":{"AT":["m"],"aQ":["m"],"M":["m"],"aJ":["m"],"A":["m"]},"fD":{"AT":["m"],"aQ":["m"],"M":["m"],"aJ":["m"],"A":["m"],"aQ.E":"m","A.E":"m"}}'))
B.rI(b.typeUniverse,JSON.parse('{"V5":1,"Va":1}'))
var y={t:"Connect Variable Header: SessionPresent={",a:"Guarded fire - event bus is closed - event not fired",h:"MqttConnectPayload - client identifier is : ",B:"MqttConnectionHandlerBase::_performConnectionDisconnect entered",p:"PublishAck Variable Header: MessageIdentifier={",w:"PublishComplete Variable Header: MessageIdentifier={",g:"PublishReceived Variable Header: MessageIdentifier={",i:"PublishRelease Variable Header: MessageIdentifier={",k:"UnsubscribeAck Variable Header: MessageIdentifier={"}
var x=(function rtii(){var w=B.U
return{h:w("xc"),Q:w("QZ<DT>"),V:w("fJ"),_:w("xL"),o:w("y1"),u:w("y2"),C:w("ct"),L:w("bg"),y:w("n<aUK>"),r:w("n<nV>"),v:w("n<kR>"),f:w("n<o3<dA>>"),p:w("n<bmp>"),d:w("n<hy<@>>"),s:w("n<i>"),t:w("n<m>"),B:w("n<D(dA?)>"),x:w("n<~(oH)>"),m:w("b8"),j:w("M<@>"),W:w("z5"),b:w("qh"),e:w("jY"),N:w("GP"),q:w("fj"),z:w("zc"),a:w("zd"),c:w("uM"),R:w("ze"),G:w("zf"),X:w("o3<dA>"),A:w("GV"),D:w("GX"),K:w("u"),k:w("A5"),P:w("c6<M<o3<dA>>>"),Z:w("AB"),E:w("hj"),U:w("eo<uM>"),J:w("eo<@>"),l:w("b_<jY?>"),Y:w("b_<~>"),w:w("aa<jY?>"),g:w("aa<~>"),M:w("hm<M<o3<dA>>>"),S:w("m"),F:w("jY?"),n:w("kR?"),T:w("i?"),i:w("D(dA?)?"),I:w("m?"),H:w("~")}})();(function constants(){var w=a.makeConstList
C.yc=new A.ml(0,"connectionAccepted")
C.yd=new A.ml(1,"unacceptedProtocolVersion")
C.ye=new A.ml(2,"identifierRejected")
C.aN=new A.ml(3,"brokerUnavailable")
C.yf=new A.ml(4,"badUsernameOrPassword")
C.yg=new A.ml(5,"notAuthorized")
C.cz=new A.ml(6,"noneSpecified")
C.Ny=w([C.yc,C.yd,C.ye,C.aN,C.yf,C.yg,C.cz],B.U("n<ml>"))
C.S2=new A.fj(0,"reserved1")
C.mN=new A.fj(1,"connect")
C.mQ=new A.fj(2,"connectAck")
C.j7=new A.fj(3,"publish")
C.j8=new A.fj(4,"publishAck")
C.j9=new A.fj(5,"publishReceived")
C.ja=new A.fj(6,"publishRelease")
C.jb=new A.fj(7,"publishComplete")
C.mR=new A.fj(8,"subscribe")
C.mS=new A.fj(9,"subscribeAck")
C.yi=new A.fj(10,"unsubscribe")
C.mO=new A.fj(11,"unsubscribeAck")
C.j5=new A.fj(12,"pingRequest")
C.j6=new A.fj(13,"pingResponse")
C.mP=new A.fj(14,"disconnect")
C.S3=new A.fj(15,"reserved2")
C.O8=w([C.S2,C.mN,C.mQ,C.j7,C.j8,C.j9,C.ja,C.jb,C.mR,C.mS,C.yi,C.mO,C.j5,C.j6,C.mP,C.S3],B.U("n<fj>"))
C.OM=w(["mqtt","mqttv3.1","mqttv3.11"],x.s)
C.Pt=w(["mqtt"],x.s)
C.cg=new A.za(1,"disconnected")
C.yh=new A.za(2,"connecting")
C.bZ=new A.za(3,"connected")
C.S_=new A.za(4,"faulted")
C.S0=new A.GS(0,"unsolicited")
C.S1=new A.GS(1,"solicited")
C.ez=new A.GS(2,"none")
C.aR=new A.kR(0,"atMostOnce")
C.bH=new A.kR(1,"atLeastOnce")
C.eA=new A.kR(2,"exactlyOnce")
C.S4=new A.kR(3,"reserved1")
C.mT=new A.kR(4,"failure")
C.a48=B.aI("@")})();(function staticFields(){$.aXy=!1
$.aXA=0})();(function lazyInitializers(){var w=a.lazyFinal
w($,"bmj","b3z",()=>new A.ao2())})()};
(a=>{a["5W8Drw2De76YvLaMZ4BvIn9k46c="]=a.current})($__dart_deferred_initializers__);