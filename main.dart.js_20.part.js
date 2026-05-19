((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,G,H,E,F,C={
b5z(){return new C.rZ(null)},
rZ:function rZ(d){this.a=d},
aaO:function aaO(d){this.a=d},
aaP:function aaP(d,e){this.a=d
this.b=e},
aaN:function aaN(d,e,f){this.a=d
this.b=e
this.c=f},
aaM:function aaM(d,e,f){this.a=d
this.b=e
this.c=f},
aaL:function aaL(d,e,f){this.a=d
this.b=e
this.c=f},
aaK:function aaK(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g}},D
J=c[1]
A=c[0]
B=c[2]
G=c[14]
H=c[24]
E=c[11]
F=c[25]
C=a.updateHolder(c[9],C)
D=c[23]
C.rZ.prototype={
J(d){var x,w=null,v=A.ms(d,!0,y.e),u=$.cD,t=(u==null?$.cD=$.fJ():u).fu("[DEFAULT]")
A.cN(t,$.fe(),!0)
x=A.yi(new A.eh(t))
if(!v.c){$.a4.ok$.push(new C.aaO(d))
return D.Vf}return A.qN(A.x6(w,B.kX,w,B.k,w,D.a2h),E.aR9(new C.aaP(this,x),A.oS(x,x.gfL().eZ("users")).GO(),y.w),w)},
afm(d,e){return E.aR9(new C.aaM(this,d,e),A.oS(d,d.gfL().eZ("users")).fd(e).eZ("reports").a4Q("reportDate",!0).GO(),y.w)},
Ao(d,e,f){return this.ahm(d,e,f)},
ahm(d,e,f){var x=0,w=A.K(y.v)
var $async$Ao=A.E(function(g,h){if(g===1)return A.H(h,w)
for(;;)switch(x){case 0:x=2
return A.L(A.oS(d,d.gfL().eZ("users")).fd(e).eZ("reports").fd(f).a.n_(),$async$Ao)
case 2:return A.I(null,w)}})
return A.J($async$Ao,w)},
Zu(d,e,f){var x=null
return A.d9(A.b([A.by(d,x,x,x,H.d4,x,x),A.by(e,x,x,x,A.eN(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.an,x,x,!0,x,x,x,x,x,x,x,x),x,x)],y.u),B.z,B.C,B.H)}}
var z=a.updateTypes(["xi(P,m)"])
C.aaO.prototype={
$1(d){var x,w,v=this.a
if(v.e!=null){v=A.dd(v,!1)
x=v.wv("/",null,y.q)
x.toString
x=A.aJg(x,B.oD,!1,null)
w=v.e
w.a4e(0,A.kr()).x6(null,!0,!0)
w.a.push(x)
w.aI()
v.rY()
v.vJ()}},
$S:5}
C.aaP.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.hD(A.by("Error: "+A.l(u),v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return F.kS
x=u.gxz()
u=this.a
w=y.u
return A.d9(A.b([A.eY(v,A.el(A.b([u.Zu("Total Users",B.d.k(x.length),B.aL),u.Zu("Status","Admin Active",B.aY)],w),B.z,B.iW,B.H,0),B.w,B.pM,v,v,v,v,v,v,B.bT,v,v,1/0),A.jM(E.aWM(new C.aaN(u,x,this.b),x.length,v,!1),1)],w),B.z,B.C,B.H)},
$S:578}
C.aaN.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.zZ()
s.toString
y.y.a(s)
x=A.acw(J.d(s.i(0,"role"),"admin")?B.aY:B.aL,D.Lx,u)
w=s.i(0,"email")
w=A.by(w==null?"No Email":w,u,u,u,u,u,u)
v=t.b.b.a
s=A.by("Role: "+A.l(s.i(0,"role"))+" | UID: "+B.c.V(B.b.gae(v),0,5)+"...",u,u,u,u,u,u)
return E.acl(E.aVD(u,A.b([this.a.afm(this.c,B.b.gae(v))],y.u),x,s,w),u,u,D.K8)},
$S:z+0}
C.aaM.prototype={
$2(d,e){var x,w=e.b
if(w==null)return D.Mw
x=w.gxz()
if(x.length===0)return D.T_
w=A.Z(x).j("a0<1,uo>")
w=A.T(new A.a0(x,new C.aaL(this.a,this.b,this.c),w),w.j("ae.E"))
return A.d9(w,B.z,B.C,B.H)},
$S:211}
C.aaL.prototype={
$1(d){var x,w,v,u=null,t=d.zZ()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.l7)w=A.aPv(x.gOw())
else if(typeof x=="string"){w=G.aV1(x)
if(w==null)w=new A.db(Date.now(),0,!1)}else w=new A.db(Date.now(),0,!1)
v=A.by(E.adz("yyyy-MM-dd HH:mm").qD(w),u,u,u,u,u,u)
return A.yS(u,!0,u,!0,!0,D.Ls,u,u,u,u,A.by("W: "+A.l(t.i(0,"weight"))+"kg | F: "+A.l(t.i(0,"bodyFatPercent"))+"% | M: "+A.l(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u),v,A.FG(u,u,u,D.Ll,u,u,new C.aaK(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:579}
C.aaK.prototype={
$0(){var x=this
return x.a.Ao(x.b,x.c,B.b.gae(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.rZ,A.am)
w(A.eF,[C.aaO,C.aaL])
w(A.ia,[C.aaP,C.aaN,C.aaM])
x(C.aaK,A.hE)})()
A.jv(b.typeUniverse,JSON.parse('{"rZ":{"am":[],"e":[]}}'))
var y={e:A.U("hp"),u:A.U("n<e>"),y:A.U("aU<i,@>"),w:A.U("vf<t?>"),q:A.U("t?"),v:A.U("~")};(function constants(){D.K8=new A.ax(10,5,10,5)
D.L1=new A.ch(57787,"MaterialIcons",!1)
D.Ll=new A.dJ(D.L1,20,B.aY,null,null)
D.Ls=new A.dJ(F.qU,20,null,null,null)
D.Lx=new A.dJ(B.mf,null,B.k,null,null)
D.Mw=new A.yR(null,null,null)
D.a2C=new A.bW("No reports found.",null,null,null,null,null,null,null,null)
D.T_=new A.bB(B.bT,D.a2C,null)
D.Vf=new A.ol(null,F.kS,null,null)
D.a2h=new A.bW("Admin Management",null,null,null,null,null,null,null,null)})()};
(a=>{a["IB2TcH0xwWNyzcQ5a3Eqx+sagy4="]=a.current})($__dart_deferred_initializers__);