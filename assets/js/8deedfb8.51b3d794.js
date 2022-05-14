"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[556],{3905:function(e,t,r){r.d(t,{Zo:function(){return c},kt:function(){return m}});var n=r(7294);function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function l(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){i(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function o(e,t){if(null==e)return{};var r,n,i=function(e,t){if(null==e)return{};var r,n,i={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(i[r]=e[r]);return i}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(i[r]=e[r])}return i}var p=n.createContext({}),u=function(e){var t=n.useContext(p),r=t;return e&&(r="function"==typeof e?e(t):l(l({},t),e)),r},c=function(e){var t=u(e.components);return n.createElement(p.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},s=n.forwardRef((function(e,t){var r=e.components,i=e.mdxType,a=e.originalType,p=e.parentName,c=o(e,["components","mdxType","originalType","parentName"]),s=u(r),m=i,h=s["".concat(p,".").concat(m)]||s[m]||d[m]||a;return r?n.createElement(h,l(l({ref:t},c),{},{components:r})):n.createElement(h,l({ref:t},c))}));function m(e,t){var r=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var a=r.length,l=new Array(a);l[0]=s;var o={};for(var p in t)hasOwnProperty.call(t,p)&&(o[p]=t[p]);o.originalType=e,o.mdxType="string"==typeof e?e:i,l[1]=o;for(var u=2;u<a;u++)l[u]=r[u];return n.createElement.apply(null,l)}return n.createElement.apply(null,r)}s.displayName="MDXCreateElement"},6437:function(e,t,r){r.r(t),r.d(t,{frontMatter:function(){return o},contentTitle:function(){return p},metadata:function(){return u},toc:function(){return c},default:function(){return s}});var n=r(7462),i=r(3366),a=(r(7294),r(3905)),l=["components"],o={},p="Changelog",u={type:"mdx",permalink:"/roact-spring/CHANGELOG",source:"@site/pages/CHANGELOG.md"},c=[{value:"Unreleased",id:"unreleased",children:[],level:2},{value:"1.0.0 (April 21, 2022)",id:"100-april-21-2022",children:[],level:2},{value:"0.3.1 (March 29, 2022)",id:"031-march-29-2022",children:[],level:2},{value:"0.3.0 (March 29, 2022)",id:"030-march-29-2022",children:[],level:2},{value:"0.2.3 (Feburary 20, 2022)",id:"023-feburary-20-2022",children:[],level:2},{value:"0.2.2 (Feburary 19, 2022)",id:"022-feburary-19-2022",children:[],level:2},{value:"0.2.1 (Feburary 17, 2022)",id:"021-feburary-17-2022",children:[],level:2},{value:"0.2.0 (Feburary 11, 2022)",id:"020-feburary-11-2022",children:[],level:2},{value:"0.1.1 (February 3, 2022)",id:"011-february-3-2022",children:[],level:2}],d={toc:c};function s(e){var t=e.components,r=(0,i.Z)(e,l);return(0,a.kt)("wrapper",(0,n.Z)({},d,r,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"changelog"},"Changelog"),(0,a.kt)("h2",{id:"unreleased"},"Unreleased"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Fixed documentation incorrectly using dot operator for controllers"),(0,a.kt)("li",{parentName:"ul"},"Fixed ",(0,a.kt)("inlineCode",{parentName:"li"},"from")," prop during imperative updates (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/lopi-py"},"@lopi-py")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/22"},"#22"),")")),(0,a.kt)("h2",{id:"100-april-21-2022"},"1.0.0 (April 21, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Bumped promise version to v4.0 (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/20"},"#20"),")"),(0,a.kt)("li",{parentName:"ul"},"Bumped roact-hooks version to v0.4 (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/20"},"#20"),")"),(0,a.kt)("li",{parentName:"ul"},"Fixed calculations not responding to fps differences (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/20"},"#20"),")")),(0,a.kt)("h2",{id:"031-march-29-2022"},"0.3.1 (March 29, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Fixed an issue where duration-based anims would always start from the same position")),(0,a.kt)("h2",{id:"030-march-29-2022"},"0.3.0 (March 29, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Removed implementation detail from return table"),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"getting started")," page to documentation"),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"reset")," prop (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/17"},"#17"),")"),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"loop")," and ",(0,a.kt)("inlineCode",{parentName:"li"},"default")," props (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/18"},"#18"),")")),(0,a.kt)("h2",{id:"023-feburary-20-2022"},"0.2.3 (Feburary 20, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Updated npm metadata"),(0,a.kt)("li",{parentName:"ul"},"Fixed library requires from packages")),(0,a.kt)("h2",{id:"022-feburary-19-2022"},"0.2.2 (Feburary 19, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"progress")," config for easing animations (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/13"},"#13"),")"),(0,a.kt)("li",{parentName:"ul"},"Hooks now cancel animations when they are unmounted"),(0,a.kt)("li",{parentName:"ul"},"Added staggered text story to demos"),(0,a.kt)("li",{parentName:"ul"},"Fixed useSprings not removing unused springs when length arg decreases"),(0,a.kt)("li",{parentName:"ul"},"Added tests for ",(0,a.kt)("inlineCode",{parentName:"li"},"useSpring")," and ",(0,a.kt)("inlineCode",{parentName:"li"},"useSprings")),(0,a.kt)("li",{parentName:"ul"},"Added rbxts typings")),(0,a.kt)("h2",{id:"021-feburary-17-2022"},"0.2.1 (Feburary 17, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Fixed ",(0,a.kt)("inlineCode",{parentName:"li"},"useTrail")," delaying the wrong amount for varying delay times"),(0,a.kt)("li",{parentName:"ul"},"Fixed typo in docs")),(0,a.kt)("h2",{id:"020-feburary-11-2022"},"0.2.0 (Feburary 11, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Fixed color3 animating with wrong values"),(0,a.kt)("li",{parentName:"ul"},"Cleaned up all stories to use circle button component"),(0,a.kt)("li",{parentName:"ul"},"Added support for hex color strings (",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie"},"@chriscerie")," in ",(0,a.kt)("a",{parentName:"li",href:"https://github.com/chriscerie/roact-spring/pull/6"},"#6"),")"),(0,a.kt)("li",{parentName:"ul"},"Added motivation in docs"),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"delay")," prop"),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"useTrail")),(0,a.kt)("li",{parentName:"ul"},"Added optional dependency array to hooks")),(0,a.kt)("h2",{id:"011-february-3-2022"},"0.1.1 (February 3, 2022)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"useSpring")),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"useSprings")),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"Controller")),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"SpringValue")),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"config")),(0,a.kt)("li",{parentName:"ul"},"Added ",(0,a.kt)("inlineCode",{parentName:"li"},"easings"))))}s.isMDXComponent=!0}}]);