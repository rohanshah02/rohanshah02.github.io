# inject_head.rb
# Injects custom CSS and JS into every rendered HTML page at build time.
# This is server-side injection — it works regardless of whether the gem's
# head template includes _includes/head_custom.html or not.

Jekyll::Hooks.register [:pages, :documents], :post_render do |page|
  next unless page.output_ext == ".html"

  injection = <<~HTML
    <style>
      /* ── Publication layout ── */
      .publications .abbr-col,.publications .preview-col{display:none!important}
      .publications .main-col{max-width:100%!important;flex:0 0 100%!important}
      ol.bibliography li{font-size:1rem!important;line-height:1.65!important}
      ol.bibliography li .title{font-size:1.05rem!important;font-weight:600!important}
      ol.bibliography li .author{font-size:.95rem!important}
      ol.bibliography li .periodical{font-size:.95rem!important}
      /* ── CV layout ── */
      .cv ul.list-group>li{list-style-type:none!important}
      .cv ul.list-group>li::marker{content:""!important}
      .cv .list-group-item{border:none!important;border-top:1px solid rgba(0,0,0,.06)!important}
      .cv .list-group-item:first-child{border-top:none!important}
      .cv .table-cv td{border:none!important}
      .cv .date-column{vertical-align:top!important}
    </style>
    <script>
    (function(){
      var N='#1b2a4a',R='#c41230',W='#ffffff';
      var V={'--global-theme-color':N,'--global-hover-color':R,'--global-hover-text-color':W,
             '--global-highlight-color':R,'--global-footer-bg-color':N,
             '--global-footer-text-color':'#e8e8e8','--global-footer-link-color':W};
      function colors(){
        var k=Object.keys(V);
        for(var i=0;i<k.length;i++){
          document.documentElement.style.setProperty(k[i],V[k[i]]);
          if(document.body)document.body.style.setProperty(k[i],V[k[i]]);
        }
      }
      function typo(){
        document.querySelectorAll('h2,h3,.card-title').forEach(function(el){
          el.style.textTransform='capitalize';
          el.querySelectorAll('a,span').forEach(function(c){c.style.textTransform='capitalize';});
        });
        var t=document.querySelector('h1.post-title');
        if(t){t.style.fontWeight='700';Array.from(t.children).forEach(function(c){c.style.fontWeight='700';});}
      }
      function run(){colors();typo();}
      if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',run);}else{run();}
      if(window.MutationObserver){
        new MutationObserver(colors).observe(document.documentElement,{attributes:true,attributeFilter:['data-theme','class']});
      }
    })();
    </script>
  HTML

  page.output = page.output.sub("</head>", injection + "</head>")
end
