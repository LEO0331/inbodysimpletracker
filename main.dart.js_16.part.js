((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,G,E,F,C={
b3n(){return new C.rC(null)},
rC:function rC(d){this.a=d},
aa4:function aa4(d){this.a=d},
aa5:function aa5(d,e){this.a=d
this.b=e},
aa3:function aa3(d,e,f){this.a=d
this.b=e
this.c=f},
aa2:function aa2(d,e,f){this.a=d
this.b=e
this.c=f},
aa1:function aa1(d,e,f){this.a=d
this.b=e
this.c=f},
aa0:function aa0(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g}},D
J=c[1]
A=c[0]
B=c[2]
G=c[16]
E=c[12]
F=c[21]
C=a.updateHolder(c[8],C)
D=c[20]
C.rC.prototype={
K(d){var x,w=null,v=A.mk(d,!0,y.e),u=$.cB,t=(u==null?$.cB=$.fE():u).fs("[DEFAULT]")
A.cH(t,$.f9(),!0)
x=A.xU(new A.ec(t))
u=v.c
if(!u){A.aU2(new C.aa4(d),y.q)
return D.V9}return A.qv(A.wK(w,B.kQ,w,B.k,w,D.a2d),E.aPa(new C.aa5(this,x),A.oJ(x,x.gfF().eX("users")).Gu(),y.w),w)},
aeM(d,e){return E.aPa(new C.aa2(this,d,e),A.oJ(d,d.gfF().eX("users")).f9(e).eX("reports").a4p("reportDate",!0).Gu(),y.w)},
A9(d,e,f){return this.agJ(d,e,f)},
agJ(d,e,f){var x=0,w=A.J(y.v)
var $async$A9=A.F(function(g,h){if(g===1)return A.G(h,w)
for(;;)switch(x){case 0:x=2
return A.M(A.oJ(d,d.gfF().eX("users")).f9(e).eX("reports").f9(f).a.mO(),$async$A9)
case 2:return A.H(null,w)}})
return A.I($async$A9,w)},
Z7(d,e,f){var x=null
return A.d6(A.b([A.bs(d,x,x,x,F.d5,x,x),A.bs(e,x,x,x,A.eK(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.am,x,x,!0,x,x,x,x,x,x,x,x),x,x)],y.u),B.z,B.C,B.F)}}
var z=a.updateTypes(["wW(R,m)"])
C.aa4.prototype={
$0(){var x,w,v=A.dj(this.a,!1),u=v.we("/",null,y.q)
u.toString
x=A.aHp(u,B.oA,!1,null)
w=v.e
w.a3Q(0,A.kg()).LV(null,!0,!0)
w.a.push(x)
w.aH()
v.vJ()
v.vr()
return u.e.a},
$S:567}
C.aa5.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.hx(A.bs("Error: "+A.k(u),v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return F.kM
x=u.gxj()
u=this.a
w=y.u
return A.d6(A.b([A.eV(v,A.eh(A.b([u.Z7("Total Users",B.d.k(x.length),B.az),u.Z7("Status","Admin Active",B.aL)],w),B.z,B.iU,B.F,0),B.w,B.pF,v,v,v,v,v,v,B.bS,v,v,1/0),A.jB(E.aUI(new C.aa3(u,x,this.b),x.length,v,!1),1)],w),B.z,B.C,B.F)},
$S:568}
C.aa3.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.zL()
s.toString
y.y.a(s)
x=A.abM(J.d(s.i(0,"role"),"admin")?B.aL:B.az,D.Lq,u)
w=s.i(0,"email")
w=A.bs(w==null?"No Email":w,u,u,u,u,u,u)
v=t.b.b.a
s=A.bs("Role: "+A.k(s.i(0,"role"))+" | UID: "+B.c.V(B.b.gac(v),0,5)+"...",u,u,u,u,u,u)
return E.abB(E.aTz(u,A.b([this.a.aeM(this.c,B.b.gac(v))],y.u),x,s,w),u,u,D.K1)},
$S:z+0}
C.aa2.prototype={
$2(d,e){var x,w=e.b
if(w==null)return D.Mp
x=w.gxj()
if(x.length===0)return D.SU
w=A.Z(x).j("a_<1,tY>")
w=A.U(new A.a_(x,new C.aa1(this.a,this.b,this.c),w),w.j("ae.E"))
return A.d6(w,B.z,B.C,B.F)},
$S:202}
C.aa1.prototype={
$1(d){var x,w,v,u=null,t=d.zL()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.l2)w=A.aNz(x.gOa())
else if(typeof x=="string"){w=G.aSX(x)
if(w==null)w=new A.d8(Date.now(),0,!1)}else w=new A.d8(Date.now(),0,!1)
v=A.bs(E.acM("yyyy-MM-dd HH:mm").qw(w),u,u,u,u,u,u)
return A.yx(u,!0,u,!0,!0,D.Ll,u,u,u,A.bs("W: "+A.k(t.i(0,"weight"))+"kg | F: "+A.k(t.i(0,"bodyFatPercent"))+"% | M: "+A.k(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u),v,A.Ff(u,u,u,D.Le,u,u,new C.aa0(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:569}
C.aa0.prototype={
$0(){var x=this
return x.a.A9(x.b,x.c,B.b.gac(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.rC,A.ar)
w(A.hy,[C.aa4,C.aa0])
w(A.jv,[C.aa5,C.aa3,C.aa2])
x(C.aa1,A.eU)})()
A.lg(b.typeUniverse,JSON.parse('{"rC":{"ar":[],"e":[]}}'))
var y={e:A.T("hw"),u:A.T("n<e>"),y:A.T("aQ<i,@>"),w:A.T("uS<x?>"),q:A.T("x?"),v:A.T("~")};(function constants(){D.K1=new A.av(10,5,10,5)
D.KV=new A.cf(57787,"MaterialIcons",!1)
D.Le=new A.dD(D.KV,20,B.aL,null,null)
D.Ll=new A.dD(F.qO,20,null,null,null)
D.Lq=new A.dD(B.m9,null,B.k,null,null)
D.Mp=new A.yv(null,null,null)
D.a2y=new A.bT("No reports found.",null,null,null,null,null,null,null,null)
D.SU=new A.by(B.bS,D.a2y,null)
D.V9=new A.oc(null,F.kM,null,null)
D.a2d=new A.bT("Admin Management",null,null,null,null,null,null,null,null)})()};
(a=>{a["Ti+hzL/0viXACP83Azdb2PfSLxk="]=a.current})($__dart_deferred_initializers__);