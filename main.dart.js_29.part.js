((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,H,E,G,F,I,K,C={
b7W(){return new C.tj(null)},
tj:function tj(d){this.a=d},
abB:function abB(d){this.a=d},
abC:function abC(d,e){this.a=d
this.b=e},
abA:function abA(d,e,f){this.a=d
this.b=e
this.c=f},
abz:function abz(d,e,f){this.a=d
this.b=e
this.c=f},
aby:function aby(d,e,f){this.a=d
this.b=e
this.c=f},
abx:function abx(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g}},D,L
J=c[1]
A=c[0]
B=c[2]
H=c[23]
E=c[18]
G=c[32]
F=c[12]
I=c[34]
K=c[31]
C=a.updateHolder(c[9],C)
D=c[30]
L=c[33]
C.tj.prototype={
J(d){var x,w=null,v=A.hN(d,!0,y.e),u=$.cx,t=(u==null?$.cx=$.fu():u).fi("[DEFAULT]")
A.cI(t,$.f_(),!0)
x=A.u7(new A.ec(t))
if(!v.c){$.a3.ok$.push(new C.abB(d))
return D.Wl}return A.kf(A.lL(w,B.l6,w,B.k,w,D.a3v),F.aTc(new C.abC(this,x),A.nm(x,x.gfE().ew("users")).Hq(),y.w),w,w)},
agD(d,e){return F.aTc(new C.abz(this,d,e),A.nm(d,d.gfE().ew("users")).eR(e).ew("reports").a63("reportDate",!0).Hq(),y.w)},
AZ(d,e,f){return this.aiJ(d,e,f)},
aiJ(d,e,f){var x=0,w=A.L(y.v)
var $async$AZ=A.G(function(g,h){if(g===1)return A.I(h,w)
for(;;)switch(x){case 0:x=2
return A.E(A.nm(d,d.gfE().ew("users")).eR(e).ew("reports").eR(f).a.m1(),$async$AZ)
case 2:return A.J(null,w)}})
return A.K($async$AZ,w)},
a_E(d,e,f){var x=null
return A.cV(A.b([A.b_(d,x,x,x,K.d8,x,x),A.b_(e,x,x,x,A.eD(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.ap,x,x,!0,x,x,x,x,x,x,x,x),x,x)],y.u),B.z,B.B,B.F)}}
var z=a.updateTypes(["xH(O,m)"])
C.abB.prototype={
$1(d){var x,w,v=this.a
if(v.e!=null){v=A.cP(v,!1)
x=v.wO("/",null,y.q)
x.toString
x=A.aLf(x,B.oM,!1,null)
w=v.e
w.a5q(0,A.kI()).xu(null,!0,!0)
w.a.push(x)
w.aG()
v.tb()
v.vX()}},
$S:5}
C.abC.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.fQ(A.b_("Error: "+A.k(u),v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return G.eb
x=u.gu8()
u=this.a
w=y.u
return A.cV(A.b([A.eM(v,A.e3(A.b([u.a_E("Total Users",B.d.k(x.length),B.aN),u.a_E("Status","Admin Active",B.b1)],w),B.z,B.j4,B.F,0),B.u,B.q_,v,v,v,v,v,v,B.bu,v,v,1/0),A.hE(E.aSo(new C.abA(u,x,this.b),x.length,v,v,!1),1)],w),B.z,B.B,B.F)},
$S:591}
C.abA.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.vM()
s.toString
y.y.a(s)
x=A.adt(J.d(s.i(0,"role"),"admin")?B.b1:B.aN,D.Mq,u)
w=s.i(0,"email")
w=A.b_(w==null?"No Email":w,u,u,u,u,u,u)
v=t.b.b.a
s=A.b_("Role: "+A.k(s.i(0,"role"))+" | UID: "+B.c.T(B.b.gae(v),0,5)+"...",u,u,u,u,u,u)
return E.Rw(F.aXT(u,A.b([this.a.agD(this.c,B.b.gae(v))],y.u),x,s,w),u,u,D.KX)},
$S:z+0}
C.abz.prototype={
$2(d,e){var x,w=e.b
if(w==null)return D.Nu
x=w.gu8()
if(x.length===0)return D.U8
w=A.Z(x).j("a1<1,uM>")
w=A.V(new A.a1(x,new C.aby(this.a,this.b,this.c),w),w.j("ae.E"))
return A.cV(w,B.z,B.B,B.F)},
$S:214}
C.aby.prototype={
$1(d){var x,w,v,u=null,t=d.vM()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.kl)w=A.aeB(x.gFa())
else if(typeof x=="string"){w=H.aRq(x)
if(w==null)w=new A.cX(Date.now(),0,!1)}else w=new A.cX(Date.now(),0,!1)
v=A.b_(E.aex("yyyy-MM-dd HH:mm",u).ni(w),u,u,u,u,u,u)
return A.qn(u,!0,u,!0,!0,D.Mk,u,u,u,u,A.b_("W: "+A.k(t.i(0,"weight"))+"kg | F: "+A.k(t.i(0,"bodyFatPercent"))+"% | M: "+A.k(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u),v,A.yX(u,u,u,D.Mc,u,u,new C.abx(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:592}
C.abx.prototype={
$0(){var x=this
return x.a.AZ(x.b,x.c,B.b.gae(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.tj,A.ag)
w(A.dZ,[C.abB,C.aby])
w(A.fS,[C.abC,C.abA,C.abz])
x(C.abx,A.fz)})()
A.fP(b.typeUniverse,JSON.parse('{"tj":{"ag":[],"e":[]}}'))
var y={e:A.T("hc"),u:A.T("n<e>"),y:A.T("aG<h,@>"),w:A.T("oz<t?>"),q:A.T("t?"),v:A.T("~")};(function constants(){D.KX=new A.au(10,5,10,5)
D.Mc=new A.d8(L.ra,20,B.b1,null,null)
D.Mk=new A.d8(I.r6,20,null,null,null)
D.Mq=new A.d8(B.mo,null,B.k,null,null)
D.Nu=new A.zh(null,null,null)
D.a3U=new A.bt("No reports found.",null,null,null,null,null,null,null,null)
D.U8=new A.br(B.bu,D.a3U,null)
D.Wl=new A.oH(null,G.eb,null,null,null)
D.a3v=new A.bt("Admin Management",null,null,null,null,null,null,null,null)})()};
(a=>{a["0a7iFmIjQAqS7fZ/duZ2mW2ldk4="]=a.current})($__dart_deferred_initializers__);