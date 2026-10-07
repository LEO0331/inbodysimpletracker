((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,H,E,G,F,I,K,C={
b7N(){return new C.tj(null)},
tj:function tj(d){this.a=d},
aby:function aby(d){this.a=d},
abz:function abz(d,e){this.a=d
this.b=e},
abx:function abx(d,e,f){this.a=d
this.b=e
this.c=f},
abw:function abw(d,e,f){this.a=d
this.b=e
this.c=f},
abv:function abv(d,e,f){this.a=d
this.b=e
this.c=f},
abu:function abu(d,e,f,g){var _=this
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
J(d){var x,w=null,v=A.i0(d,!0,y.e),u=$.cx,t=(u==null?$.cx=$.fu():u).fi("[DEFAULT]")
A.cH(t,$.f_(),!0)
x=A.u7(new A.ec(t))
if(!v.c){$.a3.ok$.push(new C.aby(d))
return D.Wj}return A.kf(A.lL(w,B.l6,w,B.k,w,D.a3v),F.aT3(new C.abz(this,x),A.nm(x,x.gfE().ev("users")).Aa(),y.w),w,w)},
agB(d,e){return F.aT3(new C.abw(this,d,e),A.nm(d,d.gfE().ev("users")).eR(e).ev("reports").Px("reportDate",!0).Aa(),y.w)},
AZ(d,e,f){return this.aiH(d,e,f)},
aiH(d,e,f){var x=0,w=A.L(y.v)
var $async$AZ=A.G(function(g,h){if(g===1)return A.I(h,w)
for(;;)switch(x){case 0:x=2
return A.F(A.nm(d,d.gfE().ev("users")).eR(e).ev("reports").eR(f).a.m_(),$async$AZ)
case 2:return A.J(null,w)}})
return A.K($async$AZ,w)},
a_E(d,e,f){var x=null
return A.cV(A.b([A.b0(d,x,x,x,K.d8,x,x),A.b0(e,x,x,x,A.eD(x,x,f,x,x,x,x,x,x,x,x,18,x,x,B.ap,x,x,!0,x,x,x,x,x,x,x,x),x,x)],y.u),B.z,B.B,B.F)}}
var z=a.updateTypes(["xH(O,m)"])
C.aby.prototype={
$1(d){var x,w,v=this.a
if(v.e!=null){v=A.cO(v,!1)
x=v.wO("/",null,y.q)
x.toString
x=A.aLa(x,B.oM,!1,null)
w=v.e
w.a5p(0,A.kI()).xu(null,!0,!0)
w.a.push(x)
w.aH()
v.ta()
v.vW()}},
$S:5}
C.abz.prototype={
$2(d,e){var x,w,v=null,u=e.c
if(u!=null)return A.fO(A.b0("Error: "+A.k(u),v,v,v,v,v,v),v,v)
u=e.b
if(u==null)return G.eb
x=u.gu7()
u=this.a
w=y.u
return A.cV(A.b([A.eM(v,A.e3(A.b([u.a_E("Total Users",B.d.k(x.length),B.aN),u.a_E("Status","Admin Active",B.b1)],w),B.z,B.j4,B.F,0),B.u,B.q_,v,v,v,v,v,v,B.bu,v,v,1/0),A.hV(E.aSg(new C.abx(u,x,this.b),x.length,v,v,!1),1)],w),B.z,B.B,B.F)},
$S:589}
C.abx.prototype={
$2(d,e){var x,w,v,u=null,t=this.b[e],s=t.vL()
s.toString
y.y.a(s)
x=A.adn(J.d(s.i(0,"role"),"admin")?B.b1:B.aN,D.Mo,u)
w=s.i(0,"email")
w=A.b0(w==null?"No Email":w,u,u,u,u,u,u)
v=t.b.b.a
s=A.b0("Role: "+A.k(s.i(0,"role"))+" | UID: "+B.c.T(B.b.gae(v),0,5)+"...",u,u,u,u,u,u)
return E.Rv(F.aXI(u,A.b([this.a.agB(this.c,B.b.gae(v))],y.u),x,s,w),u,u,D.KV)},
$S:z+0}
C.abw.prototype={
$2(d,e){var x,w=e.b
if(w==null)return D.Ns
x=w.gu7()
if(x.length===0)return D.U6
w=A.Z(x).j("a1<1,uM>")
w=A.V(new A.a1(x,new C.abv(this.a,this.b,this.c),w),w.j("ad.E"))
return A.cV(w,B.z,B.B,B.F)},
$S:214}
C.abv.prototype={
$1(d){var x,w,v,u=null,t=d.vL()
t.toString
y.y.a(t)
x=t.i(0,"reportDate")
if(x instanceof A.kl)w=A.aev(x.gF9())
else if(typeof x=="string"){w=H.aRi(x)
if(w==null)w=new A.cX(Date.now(),0,!1)}else w=new A.cX(Date.now(),0,!1)
v=A.b0(E.aer("yyyy-MM-dd HH:mm",u).nh(w),u,u,u,u,u,u)
return A.qn(u,!0,u,!0,!0,D.Mi,u,u,u,u,A.b0("W: "+A.k(t.i(0,"weight"))+"kg | F: "+A.k(t.i(0,"bodyFatPercent"))+"% | M: "+A.k(t.i(0,"muscleMass"))+"kg",u,u,u,u,u,u),v,A.yW(u,u,u,D.Ma,u,u,new C.abu(this.a,this.b,this.c,d),u,u,u,u),u)},
$S:590}
C.abu.prototype={
$0(){var x=this
return x.a.AZ(x.b,x.c,B.b.gae(x.d.b.b.a))},
$S:0};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(C.tj,A.ag)
w(A.dZ,[C.aby,C.abv])
w(A.fQ,[C.abz,C.abx,C.abw])
x(C.abu,A.fz)})()
A.fN(b.typeUniverse,JSON.parse('{"tj":{"ag":[],"e":[]}}'))
var y={e:A.T("hb"),u:A.T("n<e>"),y:A.T("aP<h,@>"),w:A.T("oy<t?>"),q:A.T("t?"),v:A.T("~")};(function constants(){D.KV=new A.au(10,5,10,5)
D.Ma=new A.d8(L.ra,20,B.b1,null,null)
D.Mi=new A.d8(I.r6,20,null,null,null)
D.Mo=new A.d8(B.mo,null,B.k,null,null)
D.Ns=new A.zg(null,null,null)
D.a3U=new A.bq("No reports found.",null,null,null,null,null,null,null,null)
D.U6=new A.bs(B.bu,D.a3U,null)
D.Wj=new A.oG(null,G.eb,null,null,null)
D.a3v=new A.bq("Admin Management",null,null,null,null,null,null,null,null)})()};
(a=>{a["rMH2bqV74TIvbdVVPO+cv0eXUH4="]=a.current})($__dart_deferred_initializers__);