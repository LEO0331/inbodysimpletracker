((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,G,E,F,H,I,K,C={
b6e(){return new C.t8(null)},
t8:function t8(d){this.a=d},
aaq:function aaq(d){this.a=d},
aar:function aar(d,e){this.a=d
this.b=e},
aap:function aap(d,e,f){this.a=d
this.b=e
this.c=f},
aao:function aao(d,e,f){this.a=d
this.b=e
this.c=f},
aan:function aan(d,e,f){this.a=d
this.b=e
this.c=f},
aam:function aam(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g}},D
J=c[1]
A=c[0]
B=c[2]
G=c[32]
E=c[17]
F=c[31]
H=c[30]
I=c[12]
K=c[33]
C=a.updateHolder(c[10],C)
D=c[29]
C.t8.prototype={
J(d){var x,w=null,v=A.fX(d,!0,y.e),u=$.ck,t=(u==null?$.ck=$.ff():u).f3("[DEFAULT]")
A.cu(t,$.eD(),!0)
x=A.pR(new A.dW(t))
if(!v.c){$.a3.ok$.push(new C.aaq(d))
return D.VO}return A.jm(A.kC(w,B.kQ,w,B.k,w,D.a2Y),A.awB(new C.aar(this,x),w,A.nd(x,x.gf1().ev("users")).GX(),y.w),w,w)},
agt(d,e){return A.awB(new C.aao(this,d,e),null,A.nd(d,d.gf1().ev("users")).eQ(e).ev("reports").P9("reportDate",!0).GX(),y.w)},
AE(d,e,f){return this.aiz(d,e,f)},
aiz(d,e,f){var x=0,w=A.M(y.v)
var $async$AE=A.H(function(g,h){if(g===1)return A.J(h,w)
for(;;)switch(x){case 0:x=2
return A.F(A.nd(d,d.gf1().ev("users")).eQ(e).ev("reports").eQ(f).a.lV(),$async$AE)
case 2:return A.K(null,w)}})
return A.L($async$AE,w)},
a_u(d,e,f){var x=null
return A.d5(A.b([A.aZ(d,x,x,x,H.jH,x,x,x),A.aZ(e,x,x,x,A.ez(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.av,x,x,!0,x,x,x,x,x,x,x,x),x,x,x)],y.u),B.A,B.C,B.N)}}
var z=a.updateTypes(["xr(O,l)"])
C.aaq.prototype={
$1(d){var x,w,v=this.a
if(v.e!=null){v=A.cH(v,!1)
x=v.ww("/",null,y.q)
x.toString
x=A.aJE(x,B.oo,!1,null)
w=v.e
w.a5f(0,A.kz()).xb(null,!0,!0)
w.a.push(x)
w.aJ()
v.rX()
v.vD()}},
$S:5}
C.aar.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.fM(A.aZ("Error: "+A.m(u),v,v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return F.e0
x=u.gqz()
u=this.a
w=y.u
return A.d5(A.b([A.f_(v,A.ei(A.b([u.a_u("Total Users",B.d.l(x.length),B.aN),u.a_u("Status","Admin Active",B.b_)],w),B.A,B.mv,B.N,0),B.v,B.pC,v,v,v,v,v,v,B.bH,v,v,1/0),A.hx(E.aQT(new C.aap(u,x,this.b),x.length,v,v,!1),1)],w),B.A,B.C,B.N)},
$S:604}
C.aap.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.rF()
s.toString
y.y.a(s)
x=A.acj(J.d(s.i(0,"role"),"admin")?B.b_:B.aN,D.M_,u)
w=s.i(0,"email")
w=A.aZ(w==null?"No Email":w,u,u,u,u,u,u,u)
v=t.b.b.a
s=A.aZ("Role: "+A.m(s.i(0,"role"))+" | UID: "+B.c.T(B.b.gae(v),0,5)+"...",u,u,u,u,u,u,u)
return E.QN(I.aWk(u,A.b([this.a.agt(this.c,B.b.gae(v))],y.u),x,s,w),u,u,D.Kv)},
$S:z+0}
C.aao.prototype={
$2(d,e){var x,w=e.b
if(w==null)return B.rp
x=w.gqz()
if(x.length===0)return D.Tw
w=A.Z(x).j("a0<1,uA>")
w=A.V(new A.a0(x,new C.aan(this.a,this.b,this.c),w),w.j("ad.E"))
return A.d5(w,B.A,B.C,B.N)},
$S:217}
C.aan.prototype={
$1(d){var x,w,v,u=null,t=d.rF()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.jt)w=A.RL(x.gyu())
else if(typeof x=="string"){w=A.aPT(x)
if(w==null)w=new A.cU(Date.now(),0,!1)}else w=new A.cU(Date.now(),0,!1)
v=A.aZ(A.aPS("yyyy-MM-dd HH:mm",u).m2(w),u,u,u,u,u,u,u)
return A.mn(u,!0,u,!0,!0,D.LU,u,u,u,u,A.aZ("W: "+A.m(t.i(0,"weight"))+"kg | F: "+A.m(t.i(0,"bodyFatPercent"))+"% | M: "+A.m(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u,u),v,A.yE(u,u,u,D.LM,u,u,new C.aam(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:605}
C.aam.prototype={
$0(){var x=this
return x.a.AE(x.b,x.c,B.b.gae(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.t8,A.ae)
w(A.ed,[C.aaq,C.aan])
w(A.ha,[C.aar,C.aap,C.aao])
x(C.aam,A.fN)})()
A.eT(b.typeUniverse,JSON.parse('{"t8":{"ae":[],"e":[]}}'))
var y={e:A.S("fL"),u:A.S("n<e>"),y:A.S("aC<h,@>"),w:A.S("k8<t?>"),q:A.S("t?"),v:A.S("~")};(function constants(){D.Kv=new A.as(10,5,10,5)
D.LM=new A.d0(G.qN,20,B.b_,null,null)
D.LU=new A.d0(K.qJ,20,null,null,null)
D.M_=new A.d0(B.m6,null,B.k,null,null)
D.a2H=new A.be("No reports found.",null,null,null,null,null,null,null,null,null)
D.Tw=new A.bn(B.bH,D.a2H,null)
D.VO=new A.oz(null,F.e0,null,null,null)
D.a2Y=new A.be("Admin Management",null,null,null,null,null,null,null,null,null)})()};
(a=>{a["NXMV9QRQhKm+9UEwaW6inHn4Dbo="]=a.current})($__dart_deferred_initializers__);