((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,E,A={afo:function afo(d){this.a=d},afp:function afp(d){this.a=d},
aV2(){var w=B.b([],x.r),v=$.cB,u=(v==null?$.cB=$.fF():v).fs("[DEFAULT]")
B.cH(u,$.f9(),!0)
v=B.xW(new B.ed(u))
v=new B.agi(v)
return new A.j5(v,w,$.aC())},
j5:function j5(d,e,f){var _=this
_.a=d
_.c=_.b=null
_.d=!1
_.e=e
_.r=_.f=!1
_.I$=0
_.M$=f
_.ae$=_.ap$=0},
anH:function anH(d,e){this.a=d
this.b=e},
anI:function anI(d,e){this.a=d
this.b=e},
a2I:function a2I(){},
Ul:function Ul(){},
anr:function anr(){},
ans:function ans(d,e,f){var _=this
_.as=d
_.a=null
_.b=e
_.d=$
_.e=null
_.f=f},
anx:function anx(){},
any:function any(d,e,f){this.a=d
this.b=e
this.c=f},
anz:function anz(d,e){this.a=d
this.b=e},
anA:function anA(d,e){this.a=d
this.b=e},
ant:function ant(){},
anu:function anu(d,e,f){this.a=d
this.b=e
this.c=f},
anv:function anv(d,e){this.a=d
this.b=e},
anw:function anw(d,e){this.a=d
this.b=e},
anB:function anB(d){this.a=d},
anC:function anC(d){this.a=d},
anD:function anD(d){this.a=d},
aw4:function aw4(d,e,f,g,h){var _=this
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
anq:function anq(d,e,f){var _=this
_.a=d
_.b=1883
_.c=e
_.d=!1
_.as=_.Q=_.z=_.y=null
_.at=0
_.ay=null
_.ch=f
_.k1=_.cx=_.CW=null},
b71(d){var w,v
for(w=d.length,v=0;v<w;++v)if(d.charCodeAt(v)>127)throw B.f(B.c9("mqtt_client::MQTTEncoding: The input string has extended UTF characters, which are not supported"))},
aSE(d){var w=new A.R_()
w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation."
if(d!=null)w.a="mqtt-client::ConnectionException: The connection must be in the Connected state in order to perform this operation. Current state is "+d.H().split(".")[1]
return w},
aja(d){var w=new A.Tu()
w.a="mqtt-client::InvalidHeaderException: "+d
return w},
aUg(d){var w=new A.Tv()
w.a="mqtt-client::InvalidMessageException: "+d
return w},
uo(d){var w=new A.UO()
w.a="mqtt-client::NoConnectionException: "+d
return w},
yR(d,e){var w=d.a
if((w.c&4)===0)w.t(0,e)
else A.aw(y.a,!1)},
aV4(d,e){if((d.c&4)!==0){A.aw("Guarded add - stream is closed - event not added",!1)
return}if(d.d==null)A.aw("Guarded add - stream has no listeners - adding anyway",!1)
d.t(0,e)},
aV0(){var w=new A.Gh(),v=new A.ik(C.aQ)
v.a=C.mF
w.a=v
v=A.aOx()
w.b=v
A.aOx()
w.c=new A.Uo(v)
return w},
aOx(){var w=new A.Up(C.aL,new A.dL())
w.hx()
return w},
b73(d){var w,v=new A.fy(new Uint8Array(0),0),u=0
do{w=d.fT()
v.og(w);++u}while(u<=4&&(w&128)===128)
return v},
b72(d){var w,v,u,t,s
for(w=B.l(d),v=new B.bK(d,d.gE(0),w.j("bK<aN.E>")),w=w.j("aN.E"),u=0,t=1;v.v();){s=v.d
u+=((s==null?w.a(s):s)&127)*t
t*=128}return u},
b75(d){var w,v,u,t,s,r
try{w=new A.ik(C.aQ)
t=new A.ik(C.aQ)
t.im(d)
w=t
if(d.a.b-d.b<w.e){d.b=0
s=A.aUg("Available bytes is less than the message size")
throw B.f(s)}s=A.b74(w,d)
return s}catch(r){s=B.a2(r)
if(x.L.b(s)){v=s
u=B.ay(r)
B.fJ(A.aUg("The data provided in the message stream was not a valid MQTT Message, exception is "+B.k(v)),u)}else throw r}},
b74(d,e){var w,v,u,t
switch(d.a){case C.mF:w=new A.Gh()
w.a=d
v=new A.Up(C.aL,new A.dL())
v.im(e)
w.b=v
A.aOx()
u=new A.Uo(v)
u.sCo(A.yP(e))
t=v.d
t===$&&B.a()
if(t.c){u.b=A.yP(e)
u.c=A.yP(e)}if(v.d.r){t=D.c.fW(A.yP(e))
u.d=t}if(v.d.f){v=D.c.fW(A.yP(e))
u.f=v}w.c=u
break
case C.mI:w=new A.Gg()
w.a=d
w.Rv(e)
v=new A.anF(C.aL,new A.dL())
v.im(e)
w.b=v
break
case C.j_:w=new A.uj()
w.a=d
w.Rv(e)
v=new A.Uy(w.a,C.aL,new A.dL())
v.hx()
v.im(e)
w.b=v
u=w.a
t=new A.Uv(u,v)
t.c=e.aGs(u.e-v.a)
w.c=t
break
case C.j0:w=new A.yS()
w.a=d
v=new A.Ut(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
break
case C.j3:w=new A.yT()
w.a=d
v=new A.Uu(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
break
case C.j1:w=new A.yU()
w.a=d
v=new A.Uw(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
break
case C.j2:w=new A.yV()
w.a=d
v=new A.Ux(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
break
case C.mJ:w=new A.Gn()
w.a=d
d.c=C.bE
v=new A.UA(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
v=new A.Uz(v,d,B.o(x.T,x.n))
v.im(e)
w.c=v
break
case C.mK:w=new A.Gm()
w.a=d
v=new A.anK(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
v=new A.anJ(v,d,B.b([],x.v))
v.im(e)
w.c=v
break
case C.y3:w=new A.UB()
w.a=d
v=new A.anQ(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
v=new A.anP(v,d,B.b([],x.s))
v.im(e)
w.c=v
break
case C.mG:w=new A.Go()
w.a=d
v=new A.anO(C.aL,new A.dL())
v.hx()
v.nm(e)
w.b=v
break
case C.iY:w=new A.Gk()
w.a=d
break
case C.iZ:w=new A.Gl()
w.a=d
break
case C.mH:w=new A.Gi()
w.a=d
break
default:throw B.f(A.aja("The Message Type specified ("+d.k(0)+".messageType) is not a valid MQTT Message type or currently not supported."))}return w},
aV3(d){var w,v,u,t
for(w=B.l(d),v=new B.bK(d,d.gE(0),w.j("bK<aN.E>")),w=w.j("aN.E"),u="";v.v();u=t){t=v.d
if(t==null)t=w.a(t)
t=u+"<"+B.k(t)+">"}return u.charCodeAt(0)==0?u:u},
b76(d){var w,v
try{w=D.ak.f8(d.dT(d))
return w}catch(v){return""}},
aV5(){var w=new A.Gn(),v=new A.ik(C.aQ)
v.a=C.mJ
w.a=v
v.c=C.bE
v=new A.UA(C.aL,new A.dL())
v.hx()
w.b=v
w.c=new A.Uz(null,null,B.o(x.T,x.n))
return w},
aOW(d){var w=new A.VV(d)
w.S7(d,B.b([A.b_g(),A.b_f(),A.bgs()],x.x))
return w},
b8h(d){var w=d.a
if(D.c.p(w,"#")||D.c.p(w,"+"))throw B.f(B.c9("mqtt_client::PublicationTopic: Cannot publish to a topic that contains MQTT topic wildcards (# or +)"))},
aPb(){var w=x.y
return new A.Ag(B.b([],w),B.b([],x.p),B.b([],w),C.mL,A.aPc("rawtopic"),new A.Qi(x.Q))},
aPc(d){var w=new A.Y1(d)
w.S7(d,B.b([A.b_g(),A.b_f(),A.bgu(),A.bgt()],x.x))
return w},
b9u(d){var w=d.a
if(D.c.p(w,"#")&&!D.c.qo(w,"#"))throw B.f(B.c9("mqtt_client::SubscriptionTopic: The rawTopic wildcard # can only be present at the end of a topic"))
if(w.length>1&&D.c.qo(w,"#")&&!D.c.qo(w,"/#"))throw B.f(B.c9("mqtt_client::SubscriptionTopic: Topics using the # wildcard longer than 1 character must be immediately preceeded by a the rawTopic separator /"))},
b9t(d){var w=d.b
w===$&&B.a()
if(D.b.i5(w,new A.aw_()))throw B.f(B.c9("mqtt_client::SubscriptionTopic: rawTopic Fragment contains a wildcard but is more than one character long"))},
ba6(d){var w=d.a.length
if(w>65535)throw B.f(B.c9("mqtt_client::Topic: The length of the supplied rawTopic ("+w+") is longer than the maximum allowable (65535)"))},
ba7(d){if(d.a.length===0)throw B.f(B.c9("mqtt_client::Topic: rawTopic must contain at least one character"))},
q1(d,e){d.jE(new A.dL().lg(e))},
yP(d){var w,v=d.jB(2)
if(v.b<2)B.S(B.c9(y.z))
w=d.jB((v.ga6(v)<<8>>>0)+v.i(0,1))
return D.dQ.bE(w.dT(w))},
aw(d,e){},
anR(d){switch(d){case 0:return C.aQ
case 1:return C.bE
case 2:return C.ey
case 128:return C.mL
default:return C.RH}},
Gj:function Gj(d,e){this.a=d
this.b=e},
yQ:function yQ(d,e){this.a=d
this.b=e},
Uq:function Uq(){},
Ur:function Ur(){},
Us:function Us(){var _=this
_.a=$
_.b=0
_.f=_.e=_.d=_.c=null
_.w=_.r=0
_.x=null
_.y=$
_.z=!1
_.as=_.Q=0},
dL:function dL(){},
QI:function QI(){this.a=$},
R_:function R_(){this.a=$},
Tm:function Tm(){this.a=$},
Tu:function Tu(){this.a=$},
Tv:function Tv(){this.a=$},
Tw:function Tw(){this.a=$},
UO:function UO(){this.a=$},
Un:function Un(d){var _=this
_.c=_.b=_.a=!1
_.d=d
_.r=_.f=_.e=!1},
Gh:function Gh(){this.b=null
this.c=$
this.a=null},
Uo:function Uo(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.e=""
_.f=null},
m8:function m8(d,e){this.a=d
this.b=e},
Up:function Up(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Gg:function Gg(){this.b=$
this.a=null},
anF:function anF(d,e){var _=this
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
Gi:function Gi(){this.a=null},
ik:function ik(d){var _=this
_.a=null
_.b=!1
_.c=d
_.d=!1
_.e=0},
du:function du(){},
fc:function fc(d,e){this.a=d
this.b=e},
anG:function anG(){},
anS:function anS(){},
Gk:function Gk(){this.a=null},
Gl:function Gl(){this.a=null},
uj:function uj(){this.b=null
this.c=$
this.a=null},
Uv:function Uv(d,e){this.a=d
this.b=e
this.c=$},
Uy:function Uy(d,e,f){var _=this
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
yS:function yS(){this.b=$
this.a=null},
Ut:function Ut(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
yT:function yT(){this.b=$
this.a=null},
Uu:function Uu(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
yU:function yU(){this.b=$
this.a=null},
Uw:function Uw(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
yV:function yV(){this.b=$
this.a=null},
Ux:function Ux(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Gn:function Gn(){var _=this
_.b=null
_.c=$
_.a=_.d=null},
Uz:function Uz(d,e,f){this.a=d
this.b=e
this.c=f},
anN:function anN(d){this.a=d},
anL:function anL(d,e){this.a=d
this.b=e},
anM:function anM(d){this.a=d},
UA:function UA(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Gm:function Gm(){this.b=null
this.c=$
this.a=null},
anJ:function anJ(d,e,f){this.a=d
this.b=e
this.c=f},
anK:function anK(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
UB:function UB(){this.b=null
this.c=$
this.a=null},
anP:function anP(d,e,f){this.a=d
this.b=e
this.c=f},
anQ:function anQ(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Go:function Go(){this.b=$
this.a=null},
anO:function anO(d,e){var _=this
_.a=0
_.b=""
_.c=0
_.d=$
_.e=0
_.f=d
_.r=""
_.w=0
_.x=e},
Gf:function Gf(){},
jO:function jO(d,e,f){this.a=d
this.b=e
this.c=f},
yK:function yK(d){this.a=d},
xn:function xn(d){this.a=d},
q_:function q_(d,e){this.a=d
this.b=e},
wO:function wO(){},
zL:function zL(d){this.a=d},
xF:function xF(){},
xE:function xE(){},
amO:function amO(){this.a=0},
kF:function kF(d,e){this.a=d
this.b=e},
nU:function nU(d,e){this.b=d
this.$ti=e},
VV:function VV(d){this.a=d
this.b=$},
VW:function VW(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=!1
_.x=j
_.y=k},
Ag:function Ag(d,e,f,g,h,i){var _=this
_.b=null
_.c=!1
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i},
aw0:function aw0(){},
aw1:function aw1(){},
Y1:function Y1(d){this.a=d
this.b=$},
aw_:function aw_(){},
Y2:function Y2(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.x=_.w=_.r=null
_.y=!0
_.z=i
_.Q=j},
ou:function ou(){},
yO:function yO(d){this.a=d
this.b=0},
anE:function anE(){this.a=null},
Um:function Um(d){var _=this
_.a=d
_.c=_.b=$
_.d=!1},
Qi:function Qi(d){this.$ti=d},
UU:function UU(){},
Dq:function Dq(){},
Ax:function Ax(){},
a1V:function a1V(){},
fy:function fy(d,e){this.a=d
this.b=e}},C
J=c[1]
B=c[0]
D=c[2]
E=c[12]
A=a.updateHolder(c[6],A)
C=c[22]
A.afo.prototype={
qO(d){var w,v=this.a,u=B.l(v)
if(B.cn(d)===C.a3Q)return d.j("c4<0>").a(new B.cu(v,u.j("cu<1>")))
else{u=u.j("cu<1>")
w=u.j("O8<c4.T>")
return new B.Dp(new B.O8(new A.afp(d),new B.cu(v,u),w),w.j("@<c4.T>").aD(d).j("Dp<1,2>"))}}}
A.j5.prototype={
gEa(){return this.f},
gaDm(){return this.r},
E1(d){return this.aCG(d)},
aCG(a0){var w=0,v=B.J(x.H),u,t=2,s=[],r=[],q=this,p,o,n,m,l,k,j,i,h,g,f,e,d
var $async$E1=B.F(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:if(q.f||q.r){w=1
break}q.r=!0
D.b.N(q.e)
if(!q.d)q.aH()
l="flutter_"+a0+"_"+Date.now()
k="inbody/users/"+a0
p=k+"/data"
o=k+"/status"
k=q.b
if(k==null){j=new A.anq("wss://broker.emqx.io/mqtt",l,new A.jO(C.ce,C.cA,C.ex))
j.b=8084
j.z=C.P6
q.b=j
k=j}k.at=20
i=A.aV0()
k=i.c
k===$&&B.a()
k.sCo(l)
k=i.b.d
k===$&&B.a()
k.b=!0
k.c=!0
h=i.c
h.b=o
h.c="offline"
k.d=C.bE
k.e=!0
q.b.sM_(i)
k=q.b
k.cx=new A.anH(q,a0)
t=4
w=7
return B.M(k.Cu(),$async$E1)
case 7:q.f=!0
k=q.b
h=p
if(k.ga0U().a!==C.bX){g=k.y
B.S(A.aSE(g==null?null:g.cy.a))}k=k.Q
if(k.aHP(h)==null)k.a1g(h,C.bE)
B.k(p)
f=new A.anE()
f.a=new A.fy(new Uint8Array(0),0)
n=f
n.av2("online")
k=q.b
k.toString
k.aG2(o,C.bE,n.a,!0)
k=q.c
if(k!=null)k.aC()
k=q.b.Q
if(k==null)k=null
else{k=k.Q
k=x.P.a(new B.cu(k,B.l(k).j("cu<1>")))}q.c=k.ee(new A.anI(q,a0))
r.push(6)
w=5
break
case 4:t=3
d=s.pop()
m=B.a2(d)
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
case 6:case 1:return B.H(u,v)
case 2:return B.G(s.at(-1),v)}})
return B.I($async$E1,v)},
AE(d,e){return this.akJ(d,e)},
akJ(d,e){var w=0,v=B.J(x.H),u=1,t=[],s=this,r,q,p,o,n
var $async$AE=B.F(function(f,g){if(f===1){t.push(g)
w=u}for(;;)switch(w){case 0:u=3
r=D.e2.a1m(d,null)
q=E.aUc("mqtt_"+Date.now(),r)
D.b.dZ(s.e,0,q)
if(!s.d)s.aH()
w=6
return B.M(s.a.BZ(e,q),$async$AE)
case 6:u=1
w=5
break
case 3:u=2
n=t.pop()
p=B.a2(n)
w=5
break
case 2:w=1
break
case 5:return B.H(null,v)
case 1:return B.G(t.at(-1),v)}})
return B.I($async$AE,v)},
ayY(){var w=this,v=w.c
if(v!=null)v.aC()
w.c=null
v=w.b
if(v!=null)v.I6(!1)
w.f=!1
if(!w.d)w.aH()},
m(){var w,v=this
v.d=!0
w=v.c
if(w!=null)w.aC()
w=v.b
if(w!=null)w.I6(!1)
v.dq()},
$iab:1}
A.a2I.prototype={}
A.Ul.prototype={
oW(d){var w,v,u,t,s,r,q,p,o,n=this,m=y.a
A.aw("MqttBrowserConnection::_onData",!1)
u=J.dA(d,0,null)
if(u.length===0){A.aw("MqttBrowserConnection::_ondata - Error - 0 byte message",!1)
return}t=n.d
t===$&&B.a()
t.a.O(0,u)
for(t=x.L,s=n.f;r=n.d,r.aDn();){w=!0
v=null
try{v=A.b75(r)}catch(q){if(t.b(B.a2(q))){A.aw("MqttBrowserConnection::_ondata - message is not yet valid, waiting for more data ...",!1)
w=!1}else throw q}if(!w){n.d.b=0
return}if(w){r=n.d
p=r.b
o=r.a
if(p<o.b){B.dw(0,p,o.gE(0),null,null)
if(p>0)o.Hx(o,0,p)}else o.sE(0,0)
r.b=0
A.aw("MqttBrowserConnection::_onData - message received ",v)
if(v.a.a===C.mI){r=v
p=s.a
if((p.c&4)===0){if(!p.gmw())B.S(p.mp())
p.ly(new A.xn(r))}else A.aw(m,!1)}else{r=v
p=s.a
if((p.c&4)===0){if(!p.gmw())B.S(p.mp())
p.ly(new A.yK(r))}else A.aw(m,!1)}A.aw("MqttBrowserConnection::_onData - message available event fired",!1)}else A.aw("MqttBrowserConnection::_onData - WARN - message available event not fired, event bus is closed",!1)}},
Z0(){var w,v,u
this.va()
A.aw("MqttBrowserConnection::_startListening",!1)
try{this.aF4()}catch(v){u=B.a2(v)
if(x.L.b(u)){w=u
A.aw("MqttBrowserConnection::_startListening - exception raised "+B.k(w),!1)}else throw v}}}
A.anr.prototype={}
A.ans.prototype={
wV(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.bn(new B.al($.ak,x.w),x.l)
A.aw("MqttBrowserWsConnection::connect - entered",!1)
w=null
try{w=B.oA(d)}catch(p){if(x.L.b(B.a2(p))){v=B.ay(p)
u="MqttBrowserWsConnection::connect - The URI supplied for the WS connection is not valid - "+d
B.fJ(A.uo(u),v)}else throw p}if(w.glj()!=="ws"&&w.glj()!=="wss")throw B.f(A.uo("MqttBrowserWsConnection::connect - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.P3(e)
t=w.gpP()
A.aw("MqttBrowserWsConnection::connect -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a_<1,i>")
m=B.U(new B.a_(m,new A.anx(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.yO(new A.fy(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.k9(s,"open",new A.any(o,k,j),!1,n)
o.b=B.k9(s,"close",new A.anz(o,j),!1,n)
o.a=B.k9(s,"error",new A.anA(o,j),!1,n)}catch(p){if(x.L.b(B.a2(p))){r=B.ay(p)
q="MqttBrowserWsConnection::connect - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fJ(A.uo(q),r)}else throw p}A.aw("MqttBrowserWsConnection::connect - connection is waiting",!1)
return j.a},
ax2(d,e){var w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=new B.bn(new B.al($.ak,x.w),x.l)
A.aw("MqttBrowserWsConnection::connectAuto - entered",!1)
w=null
try{w=B.oA(d)}catch(p){if(x.L.b(B.a2(p))){v=B.ay(p)
u="MqttBrowserWsConnection::connectAuto - The URI supplied for the WS connection is not valid - "+d
B.fJ(A.uo(u),v)}else throw p}if(w.glj()!=="ws"&&w.glj()!=="wss")throw B.f(A.uo("MqttBrowserWsConnection::connectAuto - The URI supplied for the WS has an incorrect scheme - "+d))
w=w.P3(e)
t=w.gpP()
A.aw("MqttBrowserWsConnection::connectAuto -  WS URL is "+B.k(t),!1)
try{o={}
n=b.G.WebSocket
m=k.as
l=B.Z(m).j("a_<1,i>")
m=B.U(new B.a_(m,new A.ant(),l),l.j("ae.E"))
s=new n(t,m)
k.a=s
s.binaryType="arraybuffer"
k.d=new A.yO(new A.fy(new Uint8Array(0),0))
o.a=o.b=o.c=null
n=x.m
o.c=B.k9(s,"open",new A.anu(o,k,j),!1,n)
o.b=B.k9(s,"close",new A.anv(o,j),!1,n)
o.a=B.k9(s,"error",new A.anw(o,j),!1,n)}catch(p){if(x.L.b(B.a2(p))){r=B.ay(p)
q="MqttBrowserWsConnection::connectAuto - The connection to the message broker {"+B.k(t)+"} could not be made."
B.fJ(A.uo(q),r)}else throw p}A.aw("MqttBrowserWsConnection::connectAuto - connection is waiting",!1)
return j.a},
va(){var w,v,u
for(w=this.b,v=w.length,u=0;u<w.length;w.length===v||(0,B.z)(w),++u)w[u].aC()
D.b.N(w)},
Cp(){var w=this.a
if(w!=null)w.close()},
aF4(){var w,v=this,u=v.a
if(u==null)throw B.f(B.aE("webSocket is null"))
w=x.m
return B.b([B.k9(u,"close",new A.anB(v),!1,w),B.k9(u,"message",new A.anC(v),!1,w),B.k9(u,"error",new A.anD(v),!1,w)],x.d)}}
A.aw4.prototype={
u2(d,e,f){return this.aCX(d,e,f)},
aCX(d,e,a0){var w=0,v=B.J(x.e),u,t=2,s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f
var $async$u2=B.F(function(a1,a2){if(a1===1){s.push(a2)
w=t}for(;;)switch(w){case 0:A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect entered",!1)
q=x.L
p=r.as
o=x.d
n=x.g
m=x.Y
l=r.z
k=0
case 3:A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect - initiating connection try "+k+", auto reconnect in progress "+r.f,!1)
j=r.cy
j.a=C.y2
j.b=C.cA
if(!r.f){i=new A.ans(C.On,B.b([],o),p)
h=r.at
if(h!=null)i.as=h
i.e=r.b
r.ay=i}t=7
w=!r.f?10:12
break
case 10:A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connect",!1)
j=r.ay
j===$&&B.a()
w=13
return B.M(j.wV(d,e),$async$u2)
case 13:w=11
break
case 12:A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect - calling connectAuto",!1)
j=r.ay
j===$&&B.a()
w=14
return B.M(j.ax2(d,e),$async$u2)
case 14:case 11:t=2
w=9
break
case 7:t=6
f=s.pop()
if(q.b(B.a2(f)))if(r.f)A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect exception thrown during auto reconnect - ignoring",!1)
else throw f
else throw f
w=9
break
case 6:w=2
break
case 9:A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect - connection complete",!1)
A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect sending connect message",!1)
r.kz(a0)
A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect - pre sleep, state = "+r.cy.k(0),!1)
j=r.Q
j===$&&B.a()
if(!j.d){j.b=new B.bn(new B.al($.ak,n),m)
j.c=B.ck(B.e_(0,j.a,0),j.gatj())
j.d=!0}j=j.b
j===$&&B.a()
w=15
return B.M(j.a,$async$u2)
case 15:++k
A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect - post sleep, state = "+r.cy.k(0),!1)
if(r.cy.a!==C.bX)if(!r.f)A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect failed, attempt "+k,!1)
j=r.cy.a!==C.bX
case 4:if(j&&k<l){w=3
break}case 5:if(j)if(!r.f){A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect failed",!1)
q=r.cy.b
l="The maximum allowed connection attempts ({"+l
if(q===C.cA)throw B.f(A.uo(l+"}) were exceeded. The broker is not responding to the connection request message (Missing Connection Acknowledgement?"))
else throw B.f(A.uo(l+"}) were exceeded. The broker is not responding to the connection request message correctly The return code is "+B.k(q)))}A.aw("SynchronousMqttBrowserConnectionHandler::internalConnect exited with state "+r.cy.k(0),!1)
r.cx=!0
u=r.cy
w=1
break
case 1:return B.H(u,v)
case 2:return B.G(s.at(-1),v)}})
return B.I($async$u2,v)}}
A.anq.prototype={
Cu(){var w=0,v=B.J(x.F),u,t=this,s,r,q
var $async$Cu=B.F(function(d,e){if(d===1)return B.G(e,v)
for(;;)switch(w){case 0:t.d=$.aV_=!0
s=new A.afo(new B.el(null,null,x.J))
t.k1=s
s.qO(x.u).ee(t.gaz0())
r=t.k1
if(r!=null)r.qO(x.o).ee(t.gayZ())
r=t.k1
q=new A.aw4(3,r,B.o(x.q,x.i),B.b([],x.B),new A.jO(C.ce,C.cA,C.ex))
q.Q=new A.Um(5000)
r.qO(x.h).ee(q.gavF())
r.qO(x.W).ee(q.gaEj())
r.qO(x._).ee(q.gax0())
t.y=q
w=3
return B.M(t.a9t(null,null),$async$Cu)
case 3:u=e
w=1
break
case 1:return B.H(u,v)}})
return B.I($async$Cu,v)}}
A.Gj.prototype={
H(){return"MqttDisconnectionOrigin."+this.b}}
A.yQ.prototype={
H(){return"MqttConnectionState."+this.b}}
A.Uq.prototype={
Om(){var w=this
w.va()
w.Cp()
w.a=null
if(w.e!=null){A.aw("MqttConnectionBase::_onDone - calling disconnected callback",!1)
w.e.$0()}}}
A.Ur.prototype={
wW(d,e,f){return this.awZ(d,e,f)},
awZ(d,e,f){var w=0,v=B.J(x.e),u,t=2,s=[],r=this,q,p,o
var $async$wW=B.F(function(g,h){if(g===1){s.push(h)
w=t}for(;;)switch(w){case 0:r.r=d
r.w=e
A.aw("MqttConnectionHandlerBase::connect - server "+d+", port "+e,!1)
r.x=f
t=4
w=7
return B.M(r.u2(d,e,f),$async$wW)
case 7:q=r.cy
u=q
w=1
break
t=2
w=6
break
case 4:t=3
o=s.pop()
if(x.L.b(B.a2(o))){r.cy.a=C.RC
throw o}else throw o
w=6
break
case 3:w=2
break
case 6:case 1:return B.H(u,v)
case 2:return B.G(s.at(-1),v)}})
return B.I($async$wW,v)},
Cb(d){return this.avG(d)},
avG(d){var w=0,v=B.J(x.H),u,t=this,s,r
var $async$Cb=B.F(function(e,f){if(e===1)return B.G(f,v)
for(;;)switch(w){case 0:A.aw("MqttConnectionHandlerBase::autoReconnect entered",!1)
s=t.f
if(s){w=1
break}t.f=!0
s=t.ay
s===$&&B.a()
s.va()
s.Cp()
s.a=null
t.ay.e=null
A.aw("MqttConnectionHandlerBase::autoReconnect - attempting reconnection",!1)
s=t.r
s.toString
r=t.w
r.toString
w=3
return B.M(t.wW(s,r,t.x),$async$Cb)
case 3:r=f
t.cy=r
t.f=!1
s=t.as
if(r.a===C.bX){t.ay.e=t.b
s.toString
A.yR(s,new A.zL(!0))
A.aw("MqttConnectionHandlerBase::autoReconnect - auto reconnect complete",!1)}else{A.aw("MqttConnectionHandlerBase::autoReconnect - auto reconnect failed - re trying",!1)
s.toString
A.yR(s,new A.wO())}case 1:return B.H(u,v)}})
return B.I($async$Cb,v)},
kz(d){var w,v,u,t,s
A.aw("MqttConnectionHandlerBase::sendMessage",!1)
w=this.cy.a
if(w===C.bX||w===C.y2){v=new A.yO(new A.fy(new Uint8Array(0),0))
d.i0(v)
w=v.a.b
if(0<=w)v.b=0
else v.b=w
A.aw("MqttConnectionHandlerBase::sendMessage = message is "+d.k(0),!1)
w=this.ay
w===$&&B.a()
u=J.rA(D.l.gbd(v.jB(v.a.b).a),0,null)
w=w.a
if(w!=null){t=B.a6(u)
t.toString
w.send(t)}for(w=this.CW,t=w.length,s=0;s<w.length;w.length===t||(0,B.z)(w),++s)w[s].$1(d)}else A.aw("MqttConnectionHandlerBase::sendMessage - not connected",!1)},
aEk(d){var w,v=d.a,u=v.a.a
A.aw("MqttConnectionHandlerBase::messageAvailable - message type is "+B.k(u),!1)
u.toString
w=this.ch.i(0,u)
if(w!=null)w.$1(v)
else A.aw("MqttConnectionHandlerBase::messageAvailable - WARN - no registered callback for this message type",!1)},
ax_(d){var w,v,u,t,s=this,r=y.B
A.aw("MqttConnectionHandlerBase::_connectAckProcessor",!1)
try{w=x.N.a(d)
v=w.b
v===$&&B.a()
u=!0
if(v.f!==C.aL){v=w.b
v===$&&B.a()
if(v.f!==C.y_){v=w.b
v===$&&B.a()
if(v.f!==C.xZ){v=w.b
v===$&&B.a()
if(v.f!==C.y1){v=w.b
v===$&&B.a()
v=v.f===C.y0}else v=u}else v=u}else v=u}else v=u
if(v){A.aw("MqttConnectionHandlerBase::_connectAckProcessor connection rejected",!1)
v=s.cy
u=w.b
u===$&&B.a()
v.b=u.f
A.aw(r,!1)
s.cy.a=C.ce}else{A.aw("MqttConnectionHandlerBase:_connectAckProcessor - state = connected",!1)
v=s.cy
v.a=C.bX
v.b=C.xY}}catch(t){if(x.L.b(B.a2(t))){A.aw(r,!1)
s.cy.a=C.ce}else throw t}A.aw("MqttConnectionHandlerBase:: cancelling connect timer",!1)
v=s.Q
v===$&&B.a()
if(v.d){u=v.c
u===$&&B.a()
u.aC()
v.d=!1
v=v.b
v===$&&B.a()
v.e7()}return!0},
ax1(d){var w=d.a
w.toString
this.ax_(w)}}
A.Us.prototype={
aFQ(){var w,v,u,t,s,r=this
A.aw("MqttConnectionKeepAlive::pingRequired",!1)
if(r.z)return!1
else r.z=!0
w=!1
u=new A.Gk()
t=new A.ik(C.aQ)
t.a=C.iY
u.a=t
v=u
t=r.y
t===$&&B.a()
if(t.cy.a===C.bX){A.aw("MqttConnectionKeepAlive::pingRequired - sending ping request",!1)
try{r.y.kz(v)
w=!0
r.as=Date.now()}catch(s){A.aw("MqttConnectionKeepAlive::pingRequired - exception occurred",!1)}}else A.aw("MqttConnectionKeepAlive::pingRequired - NOT sending ping - not connected",!1)
A.aw("MqttConnectionKeepAlive::pingRequired - restarting ping timer",!1)
t=r.a
t===$&&B.a()
r.c=B.ck(B.e_(0,t,0),r.ga4D())
if(r.b!==0){t=r.d
if(t==null){A.aw("MqttConnectionKeepAlive::pingRequired - starting disconnect timer",!1)
if(w)r.d=B.ck(B.e_(0,r.b,0),r.ga4c())
else r.a4b()}else{t=t.b
if(t==null)if(w){A.aw("MqttConnectionKeepAlive::pingRequired - restarting disconnect timer",!1)
r.d=B.ck(B.e_(0,r.b,0),r.ga4c())}else r.a4b()
else A.aw("MqttConnectionKeepAlive::pingRequired - disconnect timer is active, not restarting",!1)}}r.z=!1
return w},
aFP(d){var w,v=this
A.aw("MqttConnectionKeepAlive::pingRequestReceived",!1)
if(v.z)return!1
else v.z=!0
d=new A.Gl()
w=new A.ik(C.aQ)
w.a=C.iZ
d.a=w
w=v.y
w===$&&B.a()
w.kz(d)
v.z=!1
return!0},
aFS(d){var w,v,u,t=this
A.aw("MqttConnectionKeepAlive::pingResponseReceived",!1)
w=Date.now()-t.as
t.r=w
v=++t.Q
u=t.w
t.w=u+D.d.jM(w-u,v)
w=t.d
if(w!=null)w.aC()
return!0},
aEm(d){return!0},
aEF(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.bX){A.aw("MqttConnectionKeepAlive::noPingResponseReceived - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.yR(w,new A.xF())
A.aw("MqttConnectionKeepAlive::noPingResponseReceived - OK - disconnect event fired",!1)}else A.aw("MqttConnectionKeepAlive::noPingResponseReceived - ERROR - disconnect event not fired, no event handler",!1)}else A.aw("MqttConnectionKeepAlive::noPingResponseReceived - not disconnecting, not connected",!1)},
a4b(){var w=this.y
w===$&&B.a()
if(w.cy.a===C.bX){A.aw("MqttConnectionKeepAlive::noMessageSent - connected, attempting to disconnect",!1)
w=this.x
if(w!=null){A.yR(w,new A.xE())
A.aw("MqttConnectionKeepAlive::noMessageSent - OK - disconnect event fired",!1)}else A.aw("MqttConnectionKeepAlive::noMessageSent - ERROR - disconnect event not fired, no event handler",!1)}else A.aw("MqttConnectionKeepAlive::noMessageSent - not disconnecting, not connected",!1)}}
A.dL.prototype={
lg(d){var w,v,u
A.b71(d)
w=D.al.bE(d)
v=w.length
if(v>65535)throw B.f(B.c9("MqttUtf8Encoding::toUtf8 -  UTF8 string length is invalid, length is "+v))
u=new A.fy(new Uint8Array(0),0)
u.og(v>>>8)
u.og(v&255)
u.O(0,w)
return u}}
A.QI.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.R_.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.Tm.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.Tu.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.Tv.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.Tw.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.UO.prototype={
k(d){var w=this.a
w===$&&B.a()
return w},
$ibq:1}
A.Un.prototype={
ax3(){var w=this,v=w.a?1:0,u=w.b?1:0,t=w.c?1:0,s=w.d,r=w.e?1:0,q=w.f?1:0,p=w.r?1:0
return(v|u<<1|t<<2|s.a<<3|r<<5|q<<6|p<<7)>>>0},
k(d){var w=this
return"Connect Flags: Reserved1="+w.a+", CleanStart="+w.b+", WillFlag="+w.c+", WillQos="+w.d.k(0)+", WillRetain="+w.e+", PasswordFlag="+w.f+", UserNameFlag="+w.r}}
A.Gh.prototype={
a0l(d,e){return this},
i0(d){var w,v,u,t,s,r,q,p=this,o=p.a
o.toString
w=new A.dL().lg(p.b.b).b
v=p.c
v===$&&B.a()
u=new A.dL()
t=u.lg(v.e).b
s=v.a
r=s.d
r===$&&B.a()
if(r.c){r=v.b
r.toString
r=u.lg(r).b
q=v.c
q.toString
t=t+r+u.lg(q).b}if(s.d.r){r=v.d
r.toString
t+=u.lg(r).b}if(s.d.f){v=v.f
v.toString
t+=u.lg(v).b}o.kx(w+1+1+2+t,d)
o=p.b
A.q1(d,o.b)
d.nu(o.c)
v=o.d
v===$&&B.a()
d.nu(v.ax3())
d.mg(o.e)
o=p.c
A.q1(d,o.e)
v=o.a
s=v.d
s===$&&B.a()
if(s.c){s=o.b
s.toString
A.q1(d,s)
s=o.c
s.toString
A.q1(d,s)}if(v.d.r){s=o.d
s.toString
A.q1(d,s)}if(v.d.f){o=o.f
o.toString
A.q1(d,o)}},
k(d){var w=this.ix(0),v=J.b7(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(y.h+u.e+"\n")
return u.charCodeAt(0)==0?u:u}}
A.Uo.prototype={
sCo(d){var w,v=d.length
if(v>65535){w=new A.QI()
w.a="mqtt-client::ClientIdentifierException: Client id "+d+" is too long at "+v+", Maximum ClientIdentifier length is 65535"
throw B.f(w)}this.e=d},
k(d){return y.h+this.e}}
A.m8.prototype={
H(){return"MqttConnectReturnCode."+this.b}}
A.Up.prototype={
im(d){var w=this
w.aGt(d)
w.aGu(d)
w.aGl(d)
w.aGq(d)},
k(d){var w=this,v=w.b,u=w.c,t=w.d
t===$&&B.a()
return"Connect Variable Header: ProtocolName="+v+", ProtocolVersion="+u+", ConnectFlags="+t.k(0)+", KeepAlive="+w.e}}
A.Gg.prototype={
i0(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kx(2,d)
w=this.b
if(w.y)d.nu(1)
else d.nu(0)
d.nu(w.f.a)},
k(d){var w=this.ix(0),v=this.b
v===$&&B.a()
v=w+(y.t+v.y+"}, ReturnCode={"+v.f.k(0)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.anF.prototype={
im(d){d.fT()
this.aGv(d)},
k(d){return y.t+this.y+"}, ReturnCode={"+this.f.k(0)+"}"}}
A.Gi.prototype={
k(d){var w=this.ix(0)
return w.charCodeAt(0)==0?w:w}}
A.ik.prototype={
kx(d,e){var w,v,u,t,s,r=this
r.e=d
w=new A.fy(new Uint8Array(0),0)
v=r.a.a
u=r.b?1:0
t=r.c
s=r.d?1:0
w.og((v<<4>>>0)+(u<<3>>>0)+(t.a<<1>>>0)+s)
w.O(0,r.a6O())
e.jE(w)},
im(d){var w,v,u,t,s,r=this,q="The header being processed contained an invalid size byte pattern. Message size must take a most 4 bytes, and the last byte must have bit 8 set to 0."
if(d.a.b<2){d.b=0
throw B.f(A.aja("The supplied header is invalid. Header must be at least 2 bytes long."))}u=d.fT()
r.d=(u&1)===1
r.c=A.anR(u>>>1&3)
r.b=(u>>>3&1)===1
r.a=C.NL[u>>>4&15]
try{r.e=A.b72(A.b73(d))}catch(t){s=B.a2(t)
if(x.L.b(s)){w=B.ay(t)
B.fJ(A.aja(q),w)}else if(x.C.b(s)){v=B.ay(t)
B.fJ(A.aja(q),v)}else throw t}},
a6O(){var w,v,u=new A.fy(new Uint8Array(0),0),t=this.e
do{w=D.d.aS(t,128)
t=D.d.bG(t,128)
v=t>0
u.og(v?(w|128)>>>0:w)}while(v)
return u},
k(d){var w=this
return"Header: MessageType = "+B.k(w.a)+", Duplicate = "+w.b+", Retain = "+w.d+", Qos = "+w.c.k(0)+", Size = "+w.e}}
A.du.prototype={
i0(d){this.a.kx(0,d)},
im(d){return},
k(d){var w="MQTTMessage of type "+(J.b7(this.a.a)+"\n")+(J.b7(this.a)+"\n")
return w.charCodeAt(0)==0?w:w}}
A.fc.prototype={
H(){return"MqttMessageType."+this.b}}
A.anG.prototype={}
A.anS.prototype={
hx(){this.b="MQIsdp"
this.c=3
this.d=new A.Un(C.aQ)},
aGt(d){var w=A.yP(d)
this.b=w
this.a=this.a+(w.length+2)},
aGu(d){this.c=d.fT();++this.a},
aGq(d){this.e=d.a4X()
this.a+=2},
aGv(d){this.f=C.Nd[d.fT()];++this.a},
aGw(d){var w=A.yP(d)
this.r=w
this.a=w.length+2},
nm(d){this.w=d.a4X()
this.a+=2},
aGl(d){var w=new A.Un(C.aQ),v=d.fT()
w.a=(v&1)===1
w.b=(v&2)===2
w.c=(v&4)===4
w.d=A.anR(D.d.aE(v,3)&3)
w.e=(v&32)===32
w.f=(v&64)===64
w.r=(v&128)===128
this.d=w;++this.a},
gE(d){return this.a}}
A.Gk.prototype={
k(d){var w=this.ix(0)
return w.charCodeAt(0)==0?w:w}}
A.Gl.prototype={
k(d){var w=this.ix(0)
return w.charCodeAt(0)==0?w:w}}
A.uj.prototype={
i0(d){var w,v,u=this,t=u.b,s=new A.dL().lg(t.r).b
t=t.y.c
if(t===C.bE||t===C.ey)s+=2
t=u.c
t===$&&B.a()
t=t.c
t===$&&B.a()
w=t.b
u.a.kx(s+w,d)
t=u.b
A.q1(d,t.r)
v=t.y.c
if(v===C.bE||v===C.ey){t=t.w
t.toString
d.mg(t)}t=u.c.c
t===$&&B.a()
d.jE(t)},
k(d){var w=this.ix(0),v=J.b7(this.b),u=this.c
u===$&&B.a()
u=u.c
u===$&&B.a()
u=w+(v+"\n")+("Payload: {"+u.b+" bytes={"+A.aV3(u)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.Uv.prototype={
k(d){var w=this.c
w===$&&B.a()
return"Payload: {"+w.b+" bytes={"+A.aV3(w)}}
A.Uy.prototype={
im(d){var w
this.aGw(d)
w=this.y.c
if(w===C.bE||w===C.ey)this.nm(d)},
k(d){return"Publish Variable Header: TopicName={"+this.r+"}, MessageIdentifier={"+B.k(this.w)+"}, VH Length={"+this.a+"}"}}
A.yS.prototype={
i0(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kx(2,d)
w=this.b.w
w.toString
d.mg(w)},
k(d){var w=this.ix(0),v=this.b
v===$&&B.a()
v=w+(y.p+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Ut.prototype={
k(d){return y.p+B.k(this.w)+"}"}}
A.yT.prototype={
i0(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kx(2,d)
w=this.b.w
w.toString
d.mg(w)},
k(d){var w=this.ix(0),v=this.b
v===$&&B.a()
v=w+(y.w+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Uu.prototype={
k(d){return y.w+B.k(this.w)+"}"}}
A.yU.prototype={
i0(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kx(2,d)
w=this.b.w
w.toString
d.mg(w)},
k(d){var w=this.ix(0),v=this.b
v===$&&B.a()
v=w+(y.g+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Uw.prototype={
k(d){return y.g+B.k(this.w)+"}"}}
A.yV.prototype={
i0(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kx(2,d)
w=this.b.w
w.toString
d.mg(w)},
k(d){var w=this.ix(0),v=this.b
v===$&&B.a()
v=w+(y.i+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.Ux.prototype={
k(d){return y.i+B.k(this.w)+"}"}}
A.Gn.prototype={
i0(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kx(2+w.G6(),d)
w=v.b.w
w.toString
d.mg(w)
v.c.i0(d)},
aHz(d){var w
this.d=d
w=this.c
w===$&&B.a()
w.c.h(0,d,C.aQ)
return this},
avr(d){var w=this,v=w.c
v===$&&B.a()
if(v.c.G(w.d))w.c.c.h(0,w.d,d)
return w},
k(d){var w=this.ix(0),v=J.b7(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.Uz.prototype={
i0(d){this.c.ag(0,new A.anN(d))},
im(d){var w,v,u,t,s,r,q=null,p=this.b.e-this.a.a
for(w=this.c,v=0;v<p;){u=d.jB(2)
if(u.b<2)B.S(B.c9(y.z))
if(u.gE(0)===0)B.S(B.ct())
t=u.i(0,0)
if(1>=u.b)B.S(B.yd(1,u,q,q,q))
s=d.jB((t<<8>>>0)+u.a[1])
r=new B.rp(!1).vA(s.dT(s),0,q,!0)
v+=r.length+3
w.h(0,r,A.anR(d.fT()))}},
G6(){var w={}
w.a=0
this.c.ag(0,new A.anL(w,new A.dL()))
return w.a},
k(d){var w=new B.cI(""),v=this.c
w.a="Payload: Subscription [{"+v.a+"}]\n"
v.ag(0,new A.anM(w))
v=w.a
return v.charCodeAt(0)==0?v:v}}
A.UA.prototype={
k(d){return"Subscribe Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Gm.prototype={
i0(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kx(2+w.c.length,d)
w=v.b.w
w.toString
d.mg(w)
v.c.i0(d)},
k(d){var w=this.ix(0),v=J.b7(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.anJ.prototype={
i0(d){var w,v,u
for(w=this.c,v=w.length,u=0;u<w.length;w.length===v||(0,B.z)(w),++u)d.nu(w[u].a)},
im(d){var w,v,u=this.b.e-this.a.a
for(w=this.c,v=0;v<u;){++v
w.push(A.anR(d.fT()))}},
k(d){var w,v=this.c,u=v.length,t="Payload: Qos grants [{"+u+"}]\n"
for(w=0;w<v.length;v.length===u||(0,B.z)(v),++w)t+="{{ Grant={"+v[w].k(0)+"} }}\n"
return t.charCodeAt(0)==0?t:t}}
A.anK.prototype={
k(d){return"SubscribeAck Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.UB.prototype={
i0(d){var w,v=this,u=v.a
u.toString
v.b.toString
w=v.c
w===$&&B.a()
u.kx(2+w.G6(),d)
w=v.b.w
w.toString
d.mg(w)
D.b.ag(v.c.c,d.gaIh())},
k(d){var w=this.ix(0),v=J.b7(this.b),u=this.c
u===$&&B.a()
u=w+(v+"\n")+(u.k(0)+"\n")
return u.charCodeAt(0)==0?u:u}}
A.anP.prototype={
im(d){var w,v,u,t,s,r,q=null,p=this.b.e-this.a.a
for(w=this.c,v=0;v<p;){u=d.jB(2)
if(u.b<2)B.S(B.c9(y.z))
if(u.gE(0)===0)B.S(B.ct())
t=u.i(0,0)
if(1>=u.b)B.S(B.yd(1,u,q,q,q))
s=d.jB((t<<8>>>0)+u.a[1])
r=new B.rp(!1).vA(s.dT(s),0,q,!0)
v+=r.length+2
w.push(r)}},
G6(){var w,v,u,t,s=new A.dL()
for(w=this.c,v=w.length,u=0,t=0;t<w.length;w.length===v||(0,B.z)(w),++t)u+=s.lg(w[t]).b
return u},
k(d){var w,v=this.c,u=v.length,t="Payload: Unsubscription [{"+u+"}]\n"
for(w=0;w<u;++w)t+="{{ Topic={"+v[w]+"}}\n"
return t.charCodeAt(0)==0?t:t}}
A.anQ.prototype={
k(d){return"Unsubscribe VariableHeader Variable Header: MessageIdentifier={"+B.k(this.w)+"}"}}
A.Go.prototype={
i0(d){var w=this.a
w.toString
this.b===$&&B.a()
w.kx(2,d)
w=this.b.w
w.toString
d.mg(w)},
k(d){var w=this.ix(0),v=this.b
v===$&&B.a()
v=w+(y.k+B.k(v.w)+"}\n")
return v.charCodeAt(0)==0?v:v}}
A.anO.prototype={
k(d){return y.k+B.k(this.w)+"}"}}
A.Gf.prototype={
ga0U(){var w=this.y
return w!=null?w.cy:this.ch},
sM_(d){var w
this.CW=d
w=d.b
if(w!=null)w.c=3
w=d.b
if(w!=null)w.b="MQIsdp"},
wV(d,e){return this.awY(d,e)},
awY(d,e){var w=0,v=B.J(x.F),u,t=this,s,r,q,p,o,n,m
var $async$wV=B.F(function(f,g){if(f===1)return B.G(g,v)
for(;;)switch(w){case 0:if(!t.d){s=new A.Tm()
s.a="mqtt-client::ClientIncorrectInstantiationException: Incorrect instantiation, do notinstantiate MqttClient directly, use MqttServerClient or MqttBrowserClient"
throw B.f(s)}$.aV1=$.aV1+1
s=t.CW
if(s!=null)s.a0l(d,e)
r=t.y
if(r==null)throw B.f(B.aE("connectionHandler is null"))
s=t.z
if(s!=null)r.at=s
r.b=t.gaCZ()
r.e=r.d=r.c=r.a=null
A.aw("MqttClient::connect - Connection timeout period is 5000 milliseconds",!1)
s=t.k1
q=$.b0G()
p=x.S
o=x.c
s=new A.VW(q,B.o(p,o),B.o(p,o),B.o(x.I,o),B.o(x.E,x.K),r,new B.el(null,null,x.U),s)
o=r.ch
o.h(0,C.j0,s.gaBA())
o.h(0,C.j_,s.gaBy())
o.h(0,C.j3,s.gaBC())
o.h(0,C.j2,s.gaBG())
o.h(0,C.j1,s.gaBE())
t.ay=s
s.r=!1
s=t.k1
n=x.Z
q=new A.Y2(q,B.o(p,n),B.o(p,n),B.o(p,n),r,s,new B.hd(null,null,x.M))
o.h(0,C.mK,q.gawU())
o.h(0,C.mG,q.gawW())
s.qO(x.b).ee(q.gaG3())
s.qO(x.k).ee(q.gare())
t.Q=q
q.x=q.w=q.r=null
q.y=!0
s=t.at
if(s!==0){A.aw("MqttClient::connect - keep alive is enabled with a value of "+s+" seconds",!1)
s=t.k1
q=t.at
p=new A.Us()
p.y=r
p.x=s
p.a=q*1000
o.h(0,C.iY,p.gaFO())
o.h(0,C.iZ,p.gaFR())
r.CW.push(p.gaEl())
p.c=B.ck(B.e_(0,p.a,0),p.ga4D())
A.aw("MqttConnectionKeepAlive:: Initialised with a keep alive value of "+q+" seconds",!1)
A.aw("MqttConnectionKeepAlive:: Disconnect on no ping response is disabled",!1)
t.as=p}else A.aw("MqttClient::connect - keep alive is disabled",!1)
m=t.CW
if(m==null){s=A.aV0()
q=s.c
q===$&&B.a()
q.sCo(t.c)
q=s.b.d
q===$&&B.a()
q.d=C.aQ
m=s.a0l(d,e)
s=m.b.d
s===$&&B.a()
s.b=!0
t.sM_(m)}s=m.c
s===$&&B.a()
if(s.e.length===0)s.sCo(t.c)
s=m.b
if(s!=null)s.e=t.at
t.sM_(m)
u=r.wW(t.a,t.b,m)
w=1
break
case 1:return B.H(u,v)}})
return B.I($async$wV,v)},
aG2(d,e,f,g){var w,v,u,t,s,r,q,p,o,n,m=null,l=this.y,k=l==null
if((k?m:l.cy.a)!==C.bX)throw B.f(A.aSE(k?m:l.cy.a))
try{w=A.aOW(d)
l=this.ay
l.toString
k=w.a
A.aw("PublishingManager::publish - entered with topic "+k,!1)
t=l.a.G1()
s=new A.uj()
r=new A.ik(C.aQ)
r.a=C.j_
s.a=r
q=new A.Uy(r,C.aL,new A.dL())
q.hx()
s.b=q
p=new A.Uv(m,m)
o=new A.fy(new Uint8Array(0),0)
p.c=o
s.c=p
q.r=k
q.w=t
r.c=e
o.O(0,f)
r.d=!0
if(e===C.bE||e===C.ey)l.b.h(0,t,s)
l.f.kz(s)
return t}catch(n){l=B.a2(n)
if(x.L.b(l)){v=l
u=B.ay(n)
l=new A.Tw()
l.a="mqtt-client::InvalidTopicException: Topic "+d+" is "+J.b7(v)
B.fJ(l,u)}else throw n}},
az1(d){var w
A.aw("MqttClient::_disconnectOnNoPingResponse - disconnecting, no ping request response for 0 seconds",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.Om()}this.NL()},
az_(d){var w
A.aw("MqttClient::disconnectOnNoMessageSent - disconnecting, no message sent due to exception like socket exception",!1)
w=this.y
if(w!=null){w=w.ay
w===$&&B.a()
w.Om()}this.NL()},
NL(){var w=this.y
if(w==null){A.aw("MqttClient::internalDisconnect - not invoking disconnect, no connection handler",!1)
return}if(w.cx)this.I6(!0)},
I6(d){var w,v,u,t,s=this
if(!d){w=s.y
if(w!=null){A.aw("MqttConnectionHandlerBase::disconnect - entered",!1)
if(w.cy.a===C.bX){v=new A.Gi()
u=new A.ik(C.aQ)
u.a=C.mH
v.a=u
w.kz(v)}A.aw(y.B,!1)
w.cy.a=C.ce}w=s.y
if(w!=null){v=w.ay
v===$&&B.a()
v.va()
w.ay.Cp()}t=C.RE}else t=C.RD
w=s.ay
if(w!=null)w.x.b_()
s.ay=null
w=s.Q
if(w!=null)w.Q.b_()
s.Q=null
w=s.as
if(w!=null){A.aw("MqttConnectionKeepAlive::stop - stopping keep alive",!1)
w.c.aC()
v=w.d
if(v!=null)v.aC()
w.Q=w.w=w.r=0}s.as=null
w=s.ch
v=s.ga0U().b
w.b=v
s.y=null
v=s.k1
if(v!=null)v.a.b_()
s.k1=null
w.a=C.ce
w.c=t
w=s.cx
if(w!=null)w.$0()}}
A.jO.prototype={
k(d){return"Connection status is "+this.a.H().split(".")[1]+" with return code of "+J.b7(this.b).split(".")[1]+" and a disconnection origin of "+this.c.H().split(".")[1]}}
A.yK.prototype={}
A.xn.prototype={}
A.q_.prototype={}
A.wO.prototype={}
A.zL.prototype={}
A.xF.prototype={}
A.xE.prototype={}
A.amO.prototype={
G1(){var w=++this.a
return w===32768?this.a=1:w}}
A.kF.prototype={
H(){return"MqttQos."+this.b}}
A.nU.prototype={}
A.VV.prototype={}
A.VW.prototype={
aBB(d){var w,v=x.z.a(d).b
v===$&&B.a()
w=v.w
A.aw("PublishingManager::handlePublishAcknowledgement for message id "+B.k(w),!1)
v=this.b
if(v.G(w)){w.toString
this.WC(v.i(0,w))
v.F(0,w)}return!0},
aBz(d){var w,v,u,t,s,r,q,p,o,n,m=this
x.c.a(d)
w=d
v=!0
try{u=A.aOW(w.b.r)
A.aw("PublishingManager::handlePublish - publish received from broker with topic "+B.k(u),!1)
if(w.a.c===C.aQ){q=m.y
if(q!=null)A.yR(q,new A.q_(d,u))}else if(w.a.c===C.bE){q=m.y
if(q!=null)A.yR(q,new A.q_(d,u))
t=w.b.w
p=new A.yS()
q=new A.ik(C.aQ)
q.a=C.j0
p.a=q
q=new A.Ut(C.aL,new A.dL())
q.hx()
p.b=q
q.w=t
s=p
m.f.kz(s)}else if(w.a.c===C.ey){q=m.d
if(!q.G(w.b.w))q.h(0,w.b.w,w)
o=new A.yU()
q=new A.ik(C.aQ)
q.a=C.j1
o.a=q
q=new A.Uw(C.aL,new A.dL())
q.hx()
o.b=q
q.w=w.b.w
r=o
m.f.kz(r)}}catch(n){if(x.L.b(B.a2(n)))v=!1
else throw n}return v},
aBH(d){var w,v,u,t,s,r,q,p=x.G.a(d).b
p===$&&B.a()
w=p.w
A.aw("PublishingManager::handlePublishRelease - for message identifier "+B.k(w),!1)
v=!0
try{u=this.d.F(0,w)
if(u!=null){t=A.aOW(u.b.r)
p=this.y
if(p!=null)A.yR(p,new A.q_(u,t))
r=new A.yT()
p=new A.ik(C.aQ)
p.a=C.j3
r.a=p
p=new A.Uu(C.aL,new A.dL())
p.hx()
r.b=p
p.w=u.b.w
s=r
this.f.kz(s)}}catch(q){if(x.L.b(B.a2(q)))v=!1
else throw q}return v},
aBD(d){var w,v=x.a.a(d).b
v===$&&B.a()
w=v.w
A.aw("PublishingManager::handlePublishComplete - for message identifier "+B.k(w),!1)
this.WC(this.b.F(0,w))
return!0},
aBF(d){var w,v,u
x.R.a(d)
w=d.b
w===$&&B.a()
v=w.w
A.aw("PublishingManager::handlePublishReceived - for message identifier "+B.k(v),!1)
if(this.b.G(v)){u=new A.yV()
w=new A.ik(C.aQ)
w.a=C.j2
u.a=w
w.c=C.bE
w=new A.Ux(C.aL,new A.dL())
w.hx()
u.b=w
w.w=d.b.w
this.f.kz(u)}return!0},
WC(d){var w=this.x
if(w.d!=null&&d!=null){A.aw("PublishingManager::_notifyPublish - adding message to published stream for topic "+d.b.r,!1)
A.aV4(w,d)}}}
A.Ag.prototype={
gl7(){return this.w},
gr3(){var w=this.x
return w},
gxu(){var w=this.e,v=B.Z(w).j("b4<1>")
w=B.U(new B.b4(w,new A.aw0(),v),v.j("y.E"))
return w},
gzx(){var w=this.e,v=B.Z(w).j("b4<1>")
w=B.U(new B.b4(w,new A.aw1(),v),v.j("y.E"))
return w},
gA(d){var w=D.c.gA(this.gr3().a),v=B.fu(this.gl7()),u=this.c?519018:218159
return w+v+u},
aHT(d){var w,v,u=this
if(d.length!==u.gxu().length+u.gzx().length)return!1
for(w=0;w<u.gxu().length+u.gzx().length;++w)u.e[w].sl7(d[w])
v=D.b.ga6(u.e).gl7()
if(!u.c)u.w=v
return!0},
l(d,e){var w,v=this
if(e==null)return!1
if(v!==e)w=e instanceof A.Ag&&B.q(v)===B.q(e)&&v.gr3().a===e.gr3().a&&v.gl7()===e.gl7()&&v.c===e.c&&v.b==e.b
else w=!0
return w},
k(d){var w=this,v="Subscription:: Batch: "+w.c+", MID: "+B.k(w.b)+", Topic: "+w.gr3().a+", QoS: "+w.gl7().k(0)+", Total Batch: "+(w.gxu().length+w.gzx().length)+"\n"
return v.charCodeAt(0)==0?v:v}}
A.Y1.prototype={}
A.Y2.prototype={
aHP(d){var w,v,u
for(w=this.b,w=new B.bD(w,w.r,w.e,B.l(w).j("bD<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}for(w=this.c,w=new B.bD(w,w.r,w.e,B.l(w).j("bD<2>"));w.v();){v=w.d
u=v.x
if(u.a===d)return v}return null},
a1g(d,e){var w,v,u,t,s,r,q,p
try{w=A.aPc(d)
v=this.a.G1()
u=A.aPb()
u.x=w
r=u
if(!r.c)r.w=e
u.b=v
Date.now()
this.c.h(0,v,u)
r=A.aV5()
q=u.b
r.b.w=q
t=r.aHz(u.gr3().a).avr(u.gl7())
this.e.kz(t)
return u}catch(p){r=B.a2(p)
if(x.L.b(r)){s=r
A.aw("SubscriptionsManager::createNewSubscription exception raised, text is "+B.k(s),!1)
return null}else throw p}},
ayi(d){var w,v,u,t,s,r,q,p,o,n,m,l
try{w=A.aPc(D.b.ga6(d).gr3())
v=this.a.G1()
u=A.aPb()
u.c=!0
u.x=w
u.e=d
u.r=d
u.b=v
Date.now()
this.c.h(0,v,u)
q=A.aV5()
q.b.w=v
t=q
for(p=0;!1;++p){s=d[p]
o=t
n=s.gr3()
o.d=n
o=o.c
o===$&&B.a()
o.c.h(0,n,C.aQ)
n=t
o=s.gl7()
m=n.c
m===$&&B.a()
if(m.c.G(n.d))n.c.c.h(0,n.d,o)}this.e.kz(t)
return u}catch(l){o=B.a2(l)
if(x.L.b(o)){r=o
A.aw("SubscriptionsManager::createNewBatchSubscription exception raised, text is "+B.k(r),!1)
return null}else throw l}},
aG4(d){A.aV4(this.Q,B.b([new A.nU(d.a,x.X)],x.f))},
awV(d){var w,v,u,t
x.A.a(d)
w=d.b.w
w.toString
A.aPb()
v=this.c
if(v.G(w))u=v.i(0,w)
else{A.aw("SubscriptionsManager::confirmSubscription Sub Ack received for non pending subscription",!1)
return!1}if(!u.c){t=d.c
t===$&&B.a()
t=t.c
if(t.length===0||D.b.ga6(t)===C.mL){v.F(0,w)
A.aw("SubscriptionsManager::confirmSubscription failed for single subscription "+D.b.ga6(d.c.c).k(0),!1)
return!1}}else{t=d.c
t===$&&B.a()
if(!u.aHT(t.c)){v.F(0,w)
A.aw("SubscriptionsManager::confirmSubscription failed to update qos grants for batch subscription, lengths differ","Requested: 0, Received: "+d.c.c.length)
return!1}if(d.c.c.length===0||u.gxu().length===u.gxu().length+u.gzx().length){v.F(0,w)
A.aw("SubscriptionsManager::confirmSubscription all qos grants failed",!1)
return!1}}v.F(0,w)
this.b.h(0,w,u)
return!0},
awX(d){var w,v=x.D.a(d).b
v===$&&B.a()
w=v.w
v=this.d
if(v.G(w)){v.i(0,w)
this.b.F(0,null)}A.aw("SubscriptionsManager::confirmUnsubscribe subscription not found in pending unsubscriptions",!1)
return!0},
arf(d){var w,v,u,t,s,r,q,p=this
A.aw("Subscriptionsmanager::_resubscribe - resubscribing from auto reconnect "+d.a,!1)
w=p.b
v=B.l(w).j("bp<2>")
u=B.U(new B.bp(w,v),v.j("y.E"))
v=p.c
t=B.l(v).j("bp<2>")
s=B.U(new B.bp(v,t),t.j("y.E"))
w.N(0)
v.N(0)
w=B.U(u,x.Z)
D.b.O(w,s)
v=w.length
r=0
for(;r<w.length;w.length===v||(0,B.z)(w),++r){q=w[r]
if(q.c)p.ayi(q.r)
else{t=q.x
p.a1g(t.a,q.gl7())}}}}
A.ou.prototype={
gA(d){return D.c.gA(this.a)},
S7(d,e){var w,v
this.b=B.b(this.a.split("/"[0]),x.s)
for(w=e.length,v=0;v<e.length;e.length===w||(0,B.z)(e),++v)e[v].$1(this)},
l(d,e){if(e==null)return!1
if(this===e)return!0
return e instanceof A.ou&&this.a===e.a},
k(d){return this.a}}
A.yO.prototype={
gE(d){return this.a.b},
aDn(){if(this.a.b-this.b>0)return!0
return!1},
fT(){var w=this,v=w.a.i(0,w.b),u=w.b
if(u<=w.a.b-1)w.b=u+1
else return-1
return v},
a4X(){return(this.fT()<<8>>>0)+this.fT()},
jB(d){var w,v,u,t,s=this,r=null,q=s.a,p=q.b
if(p<d||s.b+d>p)throw B.f(B.c9("mqtt_client::ByteBuffer::read: The buffer does not have enough bytes for the read operation length "+s.gE(0)+", count "+d+", position "+s.b+", buffer "+q.k(q)))
if($.aV_){w=new A.fy(new Uint8Array(0),0)
p=s.b
v=p+d
B.dw(p,v,q.gE(0),r,r)
w.O(0,B.h5(q,p,v,B.l(q).j("aN.E")))
s.b+=d
u=new A.fy(new Uint8Array(0),0)
u.O(0,w)
return u}else{p=s.b+=d
v=new A.fy(new Uint8Array(0),0)
t=p-d
B.dw(t,p,q.gE(0),r,r)
v.O(0,B.h5(q,t,p,B.l(q).j("aN.E")))
return v}},
aGs(d){var w,v,u,t=this,s=t.a,r=s.b
if(r<d||t.b+d>r)throw B.f(B.c9("mqtt_client::ByteBuffer::readPayload: The buffer does not have enough bytes for the read operation length "+t.gE(0)+", count "+d+", position "+t.b+", buffer "+s.k(s)))
if(d<=32767)return t.jB(d)
r=t.b
if(r!==0){s.Fc(s,0,r)
s=t.b=0}else s=r
w=new A.fy(new Uint8Array(0),0)
r=t.a
v=r.b
if(v===d){t.b=v
s=new A.fy(new Uint8Array(0),0)
s.O(0,r)
return s}else{s+=d
B.dw(s,v,r.gE(0),null,null)
w.O(0,B.h5(r,s,v,B.l(r).j("aN.E")).dT(0))
r=t.a
r.Fc(r,t.b+d,r.b)
u=new A.fy(new Uint8Array(0),0)
u.O(0,t.a)
t.a.sE(0,0)
t.a.O(0,w)
t.b=0
return u}},
nu(d){var w=this.a,v=w.b,u=this.b
if(v===u)w.og(d)
else w.h(0,u,d);++this.b},
mg(d){this.nu(D.d.aE(d,8))
this.nu(d&255)},
jE(d){this.a.O(0,d)
this.b=this.a.b},
aIi(d){A.q1(this,d)},
k(d){var w,v=this.a
v=v.ga8(v)
if(!v){v=this.a
w=B.lW(v.dT(v),"[","]")}else w="null or empty"
return w}}
A.anE.prototype={
gE(d){return this.a.b},
av2(d){var w,v,u,t,s,r
for(w=new B.fG(d),v=x.V,w=new B.bK(w,w.gE(0),v.j("bK<aN.E>")),u=x.t,v=v.j("aN.E");w.v();){t=w.d
if(t==null)t=v.a(t)
if(t<=255&&t>=0)this.a.og(t)
else{s=new Uint16Array(B.aZ(B.b([t],u)))
t=this.a
r=J.b33(D.y5.gbd(s))
t.ZC(r,0,null)}}return this}}
A.Um.prototype={
atk(){this.d=!1
var w=this.b
w===$&&B.a()
w.e7()}}
A.Qi.prototype={}
A.UU.prototype={}
A.Dq.prototype={}
A.Ax.prototype={
gE(d){return this.b},
i(d,e){if(e>=this.b)throw B.f(B.yd(e,this,null,null,null))
return this.a[e]},
h(d,e,f){var w
if(e>=this.b)throw B.f(B.yd(e,this,null,null,null))
w=this.a
w.$flags&2&&B.a3(w)
w[e]=f},
sE(d,e){var w,v,u,t,s=this,r=s.b
if(e<r)for(w=s.a,v=w.$flags|0,u=e;u<r;++u){v&2&&B.a3(w)
w[u]=0}else{r=s.a.length
if(e>r){if(r===0)t=new Uint8Array(e)
else t=s.KC(e)
D.l.bL(t,0,s.b,s.a)
s.a=t}}s.b=e},
og(d){var w,v=this,u=v.b
if(u===v.a.length)v.ZD(u)
u=v.a
w=v.b++
u.$flags&2&&B.a3(u)
u[w]=d},
t(d,e){var w,v=this,u=v.b
if(u===v.a.length)v.ZD(u)
u=v.a
w=v.b++
u.$flags&2&&B.a3(u)
u[w]=e},
tl(d,e,f,g){B.f1(f,"start")
this.ZC(e,f,g)},
O(d,e){return this.tl(0,e,0,null)},
ZC(d,e,f){var w,v,u
if(x.j.b(d))f=J.aL(d)
if(f!=null){this.atw(this.b,d,e,f)
return}for(w=J.bt(d),v=0;w.v();){u=w.gP()
if(v>=e)this.og(u);++v}if(v<e)throw B.f(B.aE("Too few elements"))},
atw(d,e,f,g){var w,v,u,t,s=this
if(x.j.b(e)){w=J.a9(e)
if(f>w.gE(e)||g>w.gE(e))throw B.f(B.aE("Too few elements"))}v=g-f
u=s.b+v
s.atv(u)
w=s.a
t=d+v
D.l.bz(w,t,s.b+v,w,d)
D.l.bz(s.a,d,t,e,f)
s.b=u},
atv(d){var w,v=this
if(d<=v.a.length)return
w=v.KC(d)
D.l.bL(w,0,v.b,v.a)
v.a=w},
KC(d){var w=this.a.length*2
if(d!=null&&w<d)w=d
else if(w<8)w=8
return new Uint8Array(w)},
ZD(d){var w=this.KC(null)
D.l.bL(w,0,d,this.a)
this.a=w},
bz(d,e,f,g,h){var w=this.b
if(f>w)throw B.f(B.cq(f,0,w,null,null))
w=this.a
if(g instanceof A.fy)D.l.bz(w,e,f,g.a,h)
else D.l.bz(w,e,f,g,h)},
bL(d,e,f,g){return this.bz(0,e,f,g,0)}}
A.a1V.prototype={}
A.fy.prototype={}
var z=a.updateTypes(["K(du?)","~(ou)","~()","~(i?,kF?)","K(aSa)","~(L<nU<du>>)","~(wO)","~(yK)","~(xn)","K()","~(xF)","~(xE)","~(q_)","~(zL)","~(i)"])
A.afp.prototype={
$1(d){return this.a.b(d)},
$S:554}
A.anH.prototype={
$0(){var w=this.a
w.f=!1
if(!w.d)w.aH()},
$S:0}
A.anI.prototype={
$1(d){var w,v=x.c.a(J.c5(d,0).b),u=v.c
u===$&&B.a()
u=u.c
u===$&&B.a()
w=A.b76(u)
this.a.AE(w,this.b)},
$S:z+5}
A.anx.prototype={
$1(d){return d},
$S:44}
A.any.prototype={
$1(d){var w,v
A.aw("MqttBrowserWsConnection::connect - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aC()
v=w.b
if(v!=null)v.aC()
w=w.a
if(w!=null)w.aC()
this.b.Z0()
return this.c.e7()},
$S:2}
A.anz.prototype={
$1(d){var w,v
A.aw("MqttBrowserWsConnection::connect - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aC()
v=w.b
if(v!=null)v.aC()
w=w.a
if(w!=null)w.aC()
return this.b.eE(new A.jO(C.ce,C.cA,C.ex))},
$S:2}
A.anA.prototype={
$1(d){var w,v
A.aw("MqttBrowserWsConnection::connect - websocket has erred",!1)
w=this.a
v=w.c
if(v!=null)v.aC()
v=w.b
if(v!=null)v.aC()
w=w.a
if(w!=null)w.aC()
return this.b.eE(new A.jO(C.ce,C.cA,C.ex))},
$S:2}
A.ant.prototype={
$1(d){return d},
$S:44}
A.anu.prototype={
$1(d){var w,v
A.aw("MqttBrowserWsConnection::connectAuto - websocket is open",!1)
w=this.a
v=w.c
if(v!=null)v.aC()
v=w.b
if(v!=null)v.aC()
w=w.a
if(w!=null)w.aC()
this.b.Z0()
return this.c.e7()},
$S:2}
A.anv.prototype={
$1(d){var w,v
A.aw("MqttBrowserWsConnection::connectAuto - websocket is closed",!1)
w=this.a
v=w.c
if(v!=null)v.aC()
v=w.b
if(v!=null)v.aC()
w=w.a
if(w!=null)w.aC()
return this.b.eE(new A.jO(C.ce,C.cA,C.ex))},
$S:2}
A.anw.prototype={
$1(d){var w,v
A.aw("MqttBrowserWsConnection::connectAuto - websocket has errored",!1)
w=this.a
v=w.c
if(v!=null)v.aC()
v=w.b
if(v!=null)v.aC()
w=w.a
if(w!=null)w.aC()
return this.b.eE(new A.jO(C.ce,C.cA,C.ex))},
$S:2}
A.anB.prototype={
$1(d){A.aw("MqttBrowserConnection::_startListening - websocket is closed",!1)
this.a.Om()},
$S:2}
A.anC.prototype={
$1(d){this.a.oW(d.data)},
$S:2}
A.anD.prototype={
$1(d){var w
A.aw("MqttBrowserConnection::_startListening - websocket has errored",!1)
w=this.a
w.va()
w.Cp()
w.a=null
if(w.e!=null){A.aw("MqttConnectionBase::_onError - calling disconnected callback",!1)
w.e.$0()}},
$S:2}
A.anN.prototype={
$2(d,e){var w=this.a
d.toString
A.q1(w,d)
w.nu(e.a)},
$S:z+3}
A.anL.prototype={
$2(d,e){var w,v=this.a,u=v.a
d.toString
w=u+this.b.lg(d).b
v.a=w
v.a=w+1},
$S:z+3}
A.anM.prototype={
$2(d,e){var w=this.a,v="{{ Topic={"+B.k(d)+"}, Qos={"+B.k(e)+"} }}\n"
w.a+=v},
$S:z+3}
A.aw0.prototype={
$1(d){d.gl7()
return!1},
$S:z+4}
A.aw1.prototype={
$1(d){d.gl7()
return!0},
$S:z+4}
A.aw_.prototype={
$1(d){return(D.c.p(d,"#")||D.c.p(d,"+"))&&d.length>1},
$S:27};(function aliases(){var w=A.du.prototype
w.Rv=w.im
w.ix=w.k
w=A.Gf.prototype
w.a9t=w.wV})();(function installTearOffs(){var w=a._instance_0u,v=a._static_1,u=a._instance_1u
w(A.j5.prototype,"gdf","m",2)
v(A,"bgs","b8h",1)
v(A,"bgu","b9u",1)
v(A,"bgt","b9t",1)
v(A,"b_f","ba6",1)
v(A,"b_g","ba7",1)
var t
u(t=A.Ur.prototype,"gavF","Cb",6)
u(t,"gaEj","aEk",7)
u(t,"gax0","ax1",8)
w(t=A.Us.prototype,"ga4D","aFQ",9)
u(t,"gaFO","aFP",0)
u(t,"gaFR","aFS",0)
u(t,"gaEl","aEm",0)
w(t,"ga4c","aEF",2)
u(t=A.Gf.prototype,"gaz0","az1",10)
u(t,"gayZ","az_",11)
w(t,"gaCZ","NL",2)
u(t=A.VW.prototype,"gaBA","aBB",0)
u(t,"gaBy","aBz",0)
u(t,"gaBG","aBH",0)
u(t,"gaBC","aBD",0)
u(t,"gaBE","aBF",0)
u(t=A.Y2.prototype,"gaG3","aG4",12)
u(t,"gawU","awV",0)
u(t,"gawW","awX",0)
u(t,"gare","arf",13)
u(A.yO.prototype,"gaIh","aIi",14)
w(A.Um.prototype,"gatj","atk",2)})();(function inheritance(){var w=a.mixin,v=a.inheritMany,u=a.inherit
v(B.x,[A.afo,A.a2I,A.Uq,A.Ur,A.Gf,A.Us,A.dL,A.QI,A.R_,A.Tm,A.Tu,A.Tv,A.Tw,A.UO,A.Un,A.du,A.anG,A.anS,A.ik,A.jO,A.yK,A.xn,A.q_,A.wO,A.zL,A.xF,A.xE,A.amO,A.Dq,A.ou,A.VW,A.UU,A.Y2,A.yO,A.anE,A.Um,A.Qi])
v(B.eD,[A.afp,A.anI,A.anx,A.any,A.anz,A.anA,A.ant,A.anu,A.anv,A.anw,A.anB,A.anC,A.anD,A.aw0,A.aw1,A.aw_])
u(A.j5,A.a2I)
u(A.anH,B.hy)
u(A.Ul,A.Uq)
u(A.anr,A.Ur)
u(A.ans,A.Ul)
u(A.aw4,A.anr)
u(A.anq,A.Gf)
v(B.k8,[A.Gj,A.yQ,A.m8,A.fc,A.kF])
v(A.du,[A.Gh,A.Gg,A.Gi,A.Gk,A.Gl,A.uj,A.yS,A.yT,A.yU,A.yV,A.Gn,A.Gm,A.UB,A.Go])
v(A.anG,[A.Uo,A.Uv,A.Uz,A.anJ,A.anP])
v(A.anS,[A.Up,A.anF,A.Uy,A.Ut,A.Uu,A.Uw,A.Ux,A.UA,A.anK,A.anQ,A.anO])
v(B.iQ,[A.anN,A.anL,A.anM])
u(A.nU,A.Dq)
v(A.ou,[A.VV,A.Y1])
u(A.Ag,A.UU)
u(A.Ax,B.aN)
u(A.a1V,A.Ax)
u(A.fy,A.a1V)
w(A.a2I,B.aR)})()
B.jp(b.typeUniverse,JSON.parse('{"j5":{"aR":[],"ab":[]},"uj":{"du":[]},"Ag":{"UU":["Dq"]},"QI":{"bq":[]},"R_":{"bq":[]},"Tm":{"bq":[]},"Tu":{"bq":[]},"Tv":{"bq":[]},"Tw":{"bq":[]},"UO":{"bq":[]},"Gh":{"du":[]},"Gg":{"du":[]},"Gi":{"du":[]},"Gk":{"du":[]},"Gl":{"du":[]},"yS":{"du":[]},"yT":{"du":[]},"yU":{"du":[]},"yV":{"du":[]},"Gn":{"du":[]},"Gm":{"du":[]},"UB":{"du":[]},"Go":{"du":[]},"VV":{"ou":[]},"Y1":{"ou":[]},"Ax":{"aN":["1"],"L":["1"],"aI":["1"],"y":["1"]},"a1V":{"Ax":["m"],"aN":["m"],"L":["m"],"aI":["m"],"y":["m"]},"fy":{"Ax":["m"],"aN":["m"],"L":["m"],"aI":["m"],"y":["m"],"aN.E":"m","y.E":"m"}}'))
B.rm(b.typeUniverse,JSON.parse('{"Ul":1,"Uq":1}'))
var y={t:"Connect Variable Header: SessionPresent={",a:"Guarded fire - event bus is closed - event not fired",h:"MqttConnectPayload - client identifier is : ",B:"MqttConnectionHandlerBase::_performConnectionDisconnect entered",p:"PublishAck Variable Header: MessageIdentifier={",w:"PublishComplete Variable Header: MessageIdentifier={",g:"PublishReceived Variable Header: MessageIdentifier={",i:"PublishRelease Variable Header: MessageIdentifier={",k:"UnsubscribeAck Variable Header: MessageIdentifier={",z:"mqtt_client::MQTTEncoding: Length byte array must comprise 2 bytes"}
var x=(function rtii(){var w=B.T
return{h:w("wO"),Q:w("Qi<Dq>"),V:w("fG"),_:w("xn"),o:w("xE"),u:w("xF"),C:w("cp"),L:w("bq"),y:w("n<aSa>"),r:w("n<nL>"),v:w("n<kF>"),f:w("n<nU<du>>"),p:w("n<bjm>"),d:w("n<hs<@>>"),s:w("n<i>"),t:w("n<m>"),B:w("n<K(du?)>"),x:w("n<~(ou)>"),m:w("aX"),j:w("L<@>"),W:w("yK"),b:w("q_"),e:w("jO"),N:w("Gg"),q:w("fc"),z:w("yS"),a:w("yT"),c:w("uj"),R:w("yU"),G:w("yV"),X:w("nU<du>"),A:w("Gm"),D:w("Go"),K:w("x"),k:w("zL"),P:w("c4<L<nU<du>>>"),Z:w("Ag"),E:w("h8"),U:w("el<uj>"),J:w("el<@>"),l:w("bn<jO?>"),Y:w("bn<~>"),w:w("al<jO?>"),g:w("al<~>"),M:w("hd<L<nU<du>>>"),S:w("m"),F:w("jO?"),n:w("kF?"),T:w("i?"),i:w("K(du?)?"),I:w("m?"),H:w("~")}})();(function constants(){var w=a.makeConstList
C.xY=new A.m8(0,"connectionAccepted")
C.xZ=new A.m8(1,"unacceptedProtocolVersion")
C.y_=new A.m8(2,"identifierRejected")
C.aL=new A.m8(3,"brokerUnavailable")
C.y0=new A.m8(4,"badUsernameOrPassword")
C.y1=new A.m8(5,"notAuthorized")
C.cA=new A.m8(6,"noneSpecified")
C.Nd=w([C.xY,C.xZ,C.y_,C.aL,C.y0,C.y1,C.cA],B.T("n<m8>"))
C.RF=new A.fc(0,"reserved1")
C.mF=new A.fc(1,"connect")
C.mI=new A.fc(2,"connectAck")
C.j_=new A.fc(3,"publish")
C.j0=new A.fc(4,"publishAck")
C.j1=new A.fc(5,"publishReceived")
C.j2=new A.fc(6,"publishRelease")
C.j3=new A.fc(7,"publishComplete")
C.mJ=new A.fc(8,"subscribe")
C.mK=new A.fc(9,"subscribeAck")
C.y3=new A.fc(10,"unsubscribe")
C.mG=new A.fc(11,"unsubscribeAck")
C.iY=new A.fc(12,"pingRequest")
C.iZ=new A.fc(13,"pingResponse")
C.mH=new A.fc(14,"disconnect")
C.RG=new A.fc(15,"reserved2")
C.NL=w([C.RF,C.mF,C.mI,C.j_,C.j0,C.j1,C.j2,C.j3,C.mJ,C.mK,C.y3,C.mG,C.iY,C.iZ,C.mH,C.RG],B.T("n<fc>"))
C.On=w(["mqtt","mqttv3.1","mqttv3.11"],x.s)
C.P6=w(["mqtt"],x.s)
C.ce=new A.yQ(1,"disconnected")
C.y2=new A.yQ(2,"connecting")
C.bX=new A.yQ(3,"connected")
C.RC=new A.yQ(4,"faulted")
C.RD=new A.Gj(0,"unsolicited")
C.RE=new A.Gj(1,"solicited")
C.ex=new A.Gj(2,"none")
C.aQ=new A.kF(0,"atMostOnce")
C.bE=new A.kF(1,"atLeastOnce")
C.ey=new A.kF(2,"exactlyOnce")
C.RH=new A.kF(3,"reserved1")
C.mL=new A.kF(4,"failure")
C.a3Q=B.aG("@")})();(function staticFields(){$.aV_=!1
$.aV1=0})();(function lazyInitializers(){var w=a.lazyFinal
w($,"bjg","b0G",()=>new A.amO())})()};
(a=>{a["93239hLe+tX3UrxjSIeta1IA1ZQ="]=a.current})($__dart_deferred_initializers__);