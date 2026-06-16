# inject_head.rb
# Injects custom CSS and JS into every rendered HTML page at build time.

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
      /* ── Paper buttons: red outline ── */
      ol.bibliography .btn,ol.bibliography button,ol.bibliography a[role="button"],
      .publications .btn,.publications a[role="button"]{color:#c41230!important;border-color:#c41230!important;background:transparent!important}
      ol.bibliography .btn:hover,.publications .btn:hover{background:#c41230!important;color:#fff!important}
      /* ── Research page year labels: red in both modes ── */
      h2.year,h3.year,.publications h2,.publications h3{color:#c41230!important;opacity:.75!important}
      /* ── CV layout ── */
      .cv ul.list-group>li{list-style-type:none!important}
      .cv ul.list-group>li::marker{content:""!important}
      .cv .list-group-item{border:none!important;border-top:1px solid rgba(0,0,0,.08)!important;padding:1rem 1.25rem!important;overflow:hidden!important}
      .cv .list-group-item:first-child{border-top:none!important;padding-top:.25rem!important}
      /* Float the date table left so degree/job content flows to its right */
      .cv .list-group-item table{float:left!important;width:145px!important;min-width:145px!important;margin-right:1.5rem!important;border:none!important;border-collapse:collapse!important}
      .cv .list-group-item table td,.cv .list-group-item table th{border:none!important;padding:.1rem 0!important;vertical-align:top!important;background:transparent!important}
      /* Clearfix so the li expands to contain the float */
      .cv .list-group-item::after{content:""!important;display:block!important;clear:both!important}
    </style>
    <script>
    (function(){
      var N='#1b2a4a',R='#c41230',W='#ffffff';
      var V={'--global-theme-color':R,'--global-hover-color':N,'--global-hover-text-color':W,
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
      function btns(){
        /* Style publication buttons red — broad selector catches all variants */
        document.querySelectorAll(
          'ol.bibliography .btn,ol.bibliography button,ol.bibliography a[role="button"],' +
          '.publications .btn,.publications button,.publications a[role="button"],' +
          'a.abstract,a.doi,a.arxiv,a.html,a.pdf,a.slides,a.poster,a.video,a.code,a.bibtex'
        ).forEach(function(el){
          el.style.setProperty('color','#c41230','important');
          el.style.setProperty('border-color','#c41230','important');
          el.style.setProperty('background-color','transparent','important');
        });
      }
      function run(){colors();typo();btns();}
      if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',run);}else{run();}
      if(window.MutationObserver){
        new MutationObserver(colors).observe(document.documentElement,{attributes:true,attributeFilter:['data-theme','class']});
      }
    })();
    </script>
  HTML

  page.output = page.output.sub("</head>", injection + "</head>")
end
