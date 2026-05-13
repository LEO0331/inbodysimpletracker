((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,G,H,E,F,C={
b3k(){return new C.rE(null)},
rE:function rE(d){this.a=d},
aa3:function aa3(d){this.a=d},
aa4:function aa4(d,e){this.a=d
this.b=e},
aa2:function aa2(d,e,f){this.a=d
this.b=e
this.c=f},
aa1:function aa1(d,e,f){this.a=d
this.b=e
this.c=f},
aa0:function aa0(d,e,f){this.a=d
this.b=e
this.c=f},
aa_:function aa_(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g}},D
J=c[1]
A=c[0]
B=c[2]
G=c[14]
H=c[24]
E=c[10]
F=c[25]
C=a.updateHolder(c[8],C)
D=c[23]
C.rE.prototype={
K(d){var x,w=null,v=A.mk(d,!0,y.e),u=$.cB,t=(u==null?$.cB=$.fF():u).fs("[DEFAULT]")
A.cH(t,$.f9(),!0)
x=A.xW(new A.ed(t))
if(!v.c){$.a5.k4$.push(new C.aa3(d))
return D.V8}return A.qw(A.wM(w,B.kP,w,B.k,w,D.a2c),E.aP8(new C.aa4(this,x),A.oL(x,x.gfF().eX("users")).Gv(),y.w),w)},
aeM(d,e){return E.aP8(new C.aa1(this,d,e),A.oL(d,d.gfF().eX("users")).f9(e).eX("reports").a4p("reportDate",!0).Gv(),y.w)},
Ab(d,e,f){return this.agJ(d,e,f)},
agJ(d,e,f){var x=0,w=A.J(y.v)
var $async$Ab=A.F(function(g,h){if(g===1)return A.G(h,w)
for(;;)switch(x){case 0:x=2
return A.M(A.oL(d,d.gfF().eX("users")).f9(e).eX("reports").f9(f).a.mP(),$async$Ab)
case 2:return A.H(null,w)}})
return A.I($async$Ab,w)},
Z7(d,e,f){var x=null
return A.d6(A.b([A.bs(d,x,x,x,H.d5,x,x),A.bs(e,x,x,x,A.eL(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.am,x,x,!0,x,x,x,x,x,x,x,x),x,x)],y.u),B.z,B.C,B.F)}}
var z=a.updateTypes(["wY(R,m)"])
C.aa3.prototype={
$1(d){var x,w,v=this.a
if(v.e!=null){v=A.dv(v,!1)
x=v.wf("/",null,y.q)
x.toString
x=A.aHo(x,B.oA,!1,null)
w=v.e
w.a3Q(0,A.ki()).LW(null,!0,!0)
w.a.push(x)
w.aH()
v.vK()
v.vs()}},
$S:5}
C.aa4.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.hx(A.bs("Error: "+A.k(u),v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return F.kL
x=u.gxk()
u=this.a
w=y.u
return A.d6(A.b([A.eV(v,A.ei(A.b([u.Z7("Total Users",B.d.k(x.length),B.aK),u.Z7("Status","Admin Active",B.aW)],w),B.z,B.iT,B.F,0),B.w,B.pF,v,v,v,v,v,v,B.bS,v,v,1/0),A.jD(E.aUF(new C.aa2(u,x,this.b),x.length,v,!1),1)],w),B.z,B.C,B.F)},
$S:567}
C.aa2.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.zN()
s.toString
y.y.a(s)
x=A.abL(J.d(s.i(0,"role"),"admin")?B.aW:B.aK,D.Lp,u)
w=s.i(0,"email")
w=A.bs(w==null?"No Email":w,u,u,u,u,u,u)
v=t.b.b.a
s=A.bs("Role: "+A.k(s.i(0,"role"))+" | UID: "+B.c.V(B.b.gac(v),0,5)+"...",u,u,u,u,u,u)
return E.abA(E.aTx(u,A.b([this.a.aeM(this.c,B.b.gac(v))],y.u),x,s,w),u,u,D.K0)},
$S:z+0}
C.aa1.prototype={
$2(d,e){var x,w=e.b
if(w==null)return D.Mo
x=w.gxk()
if(x.length===0)return D.ST
w=A.Z(x).j("a_<1,u0>")
w=A.U(new A.a_(x,new C.aa0(this.a,this.b,this.c),w),w.j("ae.E"))
return A.d6(w,B.z,B.C,B.F)},
$S:124}
C.aa0.prototype={
$1(d){var x,w,v,u=null,t=d.zN()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.l3)w=A.aNy(x.gOb())
else if(typeof x=="string"){w=G.aSV(x)
if(w==null)w=new A.d8(Date.now(),0,!1)}else w=new A.d8(Date.now(),0,!1)
v=A.bs(E.acL("yyyy-MM-dd HH:mm").qx(w),u,u,u,u,u,u)
return A.yy(u,!0,u,!0,!0,D.Lk,u,u,u,A.bs("W: "+A.k(t.i(0,"weight"))+"kg | F: "+A.k(t.i(0,"bodyFatPercent"))+"% | M: "+A.k(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u),v,A.Ff(u,u,u,D.Ld,u,u,new C.aa_(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:568}
C.aa_.prototype={
$0(){var x=this
return x.a.Ab(x.b,x.c,B.b.gac(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.rE,A.ar)
w(A.eD,[C.aa3,C.aa0])
w(A.iQ,[C.aa4,C.aa2,C.aa1])
x(C.aa_,A.hy)})()
A.jp(b.typeUniverse,JSON.parse('{"rE":{"ar":[],"e":[]}}'))
var y={e:A.T("hi"),u:A.T("n<e>"),y:A.T("aQ<i,@>"),w:A.T("uV<x?>"),q:A.T("x?"),v:A.T("~")};(function constants(){D.K0=new A.av(10,5,10,5)
D.KU=new A.cf(57787,"MaterialIcons",!1)
D.Ld=new A.dD(D.KU,20,B.aW,null,null)
D.Lk=new A.dD(F.qO,20,null,null,null)
D.Lp=new A.dD(B.m8,null,B.k,null,null)
D.Mo=new A.yw(null,null,null)
D.a2x=new A.bT("No reports found.",null,null,null,null,null,null,null,null)
D.ST=new A.by(B.bS,D.a2x,null)
D.V8=new A.oe(null,F.kL,null,null)
D.a2c=new A.bT("Admin Management",null,null,null,null,null,null,null,null)})()};
(a=>{a["5YQ45yOsXkPFinG7IMe6qC97f4M="]=a.current})($__dart_deferred_initializers__);