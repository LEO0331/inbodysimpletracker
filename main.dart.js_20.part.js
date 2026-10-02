((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,G,H,E,F,C={
b65(){return new C.t3(null)},
t3:function t3(d){this.a=d},
aaU:function aaU(d){this.a=d},
aaV:function aaV(d,e){this.a=d
this.b=e},
aaT:function aaT(d,e,f){this.a=d
this.b=e
this.c=f},
aaS:function aaS(d,e,f){this.a=d
this.b=e
this.c=f},
aaR:function aaR(d,e,f){this.a=d
this.b=e
this.c=f},
aaQ:function aaQ(d,e,f,g){var _=this
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
C.t3.prototype={
J(d){var x,w=null,v=A.mz(d,!0,y.e),u=$.cD,t=(u==null?$.cD=$.fI():u).fA("[DEFAULT]")
A.cO(t,$.fe(),!0)
x=A.yo(new A.eh(t))
if(!v.c){$.a3.ok$.push(new C.aaU(d))
return D.Vw}return A.qR(A.xa(w,B.kY,w,B.k,w,D.a2w),E.aRx(new C.aaV(this,x),A.oY(x,x.gfN().f_("users")).H_(),y.w),w)},
ag5(d,e){return E.aRx(new C.aaS(this,d,e),A.oY(d,d.gfN().f_("users")).fg(e).f_("reports").a5A("reportDate",!0).H_(),y.w)},
AB(d,e,f){return this.ai7(d,e,f)},
ai7(d,e,f){var x=0,w=A.K(y.v)
var $async$AB=A.G(function(g,h){if(g===1)return A.H(h,w)
for(;;)switch(x){case 0:x=2
return A.F(A.oY(d,d.gfN().f_("users")).fg(e).f_("reports").fg(f).a.n0(),$async$AB)
case 2:return A.I(null,w)}})
return A.J($async$AB,w)},
a_5(d,e,f){var x=null
return A.db(A.b([A.bw(d,x,x,x,H.d5,x,x),A.bw(e,x,x,x,A.eN(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.an,x,x,!0,x,x,x,x,x,x,x,x),x,x)],y.u),B.z,B.C,B.J)}}
var z=a.updateTypes(["xn(Q,m)"])
C.aaU.prototype={
$1(d){var x,w,v=this.a
if(v.e!=null){v=A.df(v,!1)
x=v.wC("/",null,y.q)
x.toString
x=A.aJD(x,B.oG,!1,null)
w=v.e
w.a4Y(0,A.kw()).xf(null,!0,!0)
w.a.push(x)
w.aI()
v.t6()
v.vN()}},
$S:5}
C.aaV.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.hE(A.bw("Error: "+A.k(u),v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return F.kT
x=u.gxH()
u=this.a
w=y.u
return A.db(A.b([A.eX(v,A.el(A.b([u.a_5("Total Users",B.d.k(x.length),B.aM),u.a_5("Status","Admin Active",B.aZ)],w),B.z,B.j_,B.J,0),B.w,B.pR,v,v,v,v,v,v,B.bU,v,v,1/0),A.jO(E.aXd(new C.aaT(u,x,this.b),x.length,v,!1),1)],w),B.z,B.C,B.J)},
$S:582}
C.aaT.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.Aa()
s.toString
y.y.a(s)
x=A.acD(J.d(s.i(0,"role"),"admin")?B.aZ:B.aM,D.LH,u)
w=s.i(0,"email")
w=A.bw(w==null?"No Email":w,u,u,u,u,u,u)
v=t.b.b.a
s=A.bw("Role: "+A.k(s.i(0,"role"))+" | UID: "+B.c.T(B.b.gae(v),0,5)+"...",u,u,u,u,u,u)
return E.acs(E.aW3(u,A.b([this.a.ag5(this.c,B.b.gae(v))],y.u),x,s,w),u,u,D.Ki)},
$S:z+0}
C.aaS.prototype={
$2(d,e){var x,w=e.b
if(w==null)return D.MG
x=w.gxH()
if(x.length===0)return D.Th
w=A.Z(x).j("a0<1,us>")
w=A.T(new A.a0(x,new C.aaR(this.a,this.b,this.c),w),w.j("ae.E"))
return A.db(w,B.z,B.C,B.J)},
$S:212}
C.aaR.prototype={
$1(d){var x,w,v,u=null,t=d.Aa()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.ld)w=A.aPP(x.gOS())
else if(typeof x=="string"){w=G.aVt(x)
if(w==null)w=new A.dd(Date.now(),0,!1)}else w=new A.dd(Date.now(),0,!1)
v=A.bw(E.adH("yyyy-MM-dd HH:mm").qP(w),u,u,u,u,u,u)
return A.yW(u,!0,u,!0,!0,D.LC,u,u,u,u,A.bw("W: "+A.k(t.i(0,"weight"))+"kg | F: "+A.k(t.i(0,"bodyFatPercent"))+"% | M: "+A.k(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u),v,A.FO(u,u,u,D.Lv,u,u,new C.aaQ(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:583}
C.aaQ.prototype={
$0(){var x=this
return x.a.AB(x.b,x.c,B.b.gae(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.t3,A.an)
w(A.eF,[C.aaU,C.aaR])
w(A.i8,[C.aaV,C.aaT,C.aaS])
x(C.aaQ,A.hF)})()
A.jy(b.typeUniverse,JSON.parse('{"t3":{"an":[],"f":[]}}'))
var y={e:A.U("hr"),u:A.U("n<f>"),y:A.U("aT<i,@>"),w:A.U("vi<u?>"),q:A.U("u?"),v:A.U("~")};(function constants(){D.Ki=new A.ax(10,5,10,5)
D.Lb=new A.cj(57787,"MaterialIcons",!1)
D.Lv=new A.dK(D.Lb,20,B.aZ,null,null)
D.LC=new A.dK(F.qZ,20,null,null,null)
D.LH=new A.dK(B.mg,null,B.k,null,null)
D.MG=new A.yV(null,null,null)
D.a2R=new A.bY("No reports found.",null,null,null,null,null,null,null,null)
D.Th=new A.bC(B.bU,D.a2R,null)
D.Vw=new A.oq(null,F.kT,null,null)
D.a2w=new A.bY("Admin Management",null,null,null,null,null,null,null,null)})()};
(a=>{a["UcnJpBGbH6tavqu4oS+Wvo5IHuc="]=a.current})($__dart_deferred_initializers__);