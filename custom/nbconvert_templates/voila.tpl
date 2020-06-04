{%- extends 'base.tpl' -%}
{% from 'mathjax.tpl' import mathjax %}

{# this overrides the default behaviour of directly starting the kernel and executing the notebook #}
{% block notebook_execute %}
{% endblock notebook_execute %}


{%- block html_head_css -%}
<link rel="stylesheet" type="text/css" href="{{resources.base_url}}voila/static/index.css">

{% if resources.theme == 'dark' %}
<link rel="stylesheet" type="text/css" href="{{resources.base_url}}voila/static/theme-dark.css">
{% else %}
<link rel="stylesheet" type="text/css" href="{{resources.base_url}}voila/static/theme-light.css">
{% endif %}

{% for css in resources.inlining.css %}
<style>
  {{ css }}
</style>
{% endfor %}

<style>
  a.anchor-link {
  display: none;
}
.highlight  {
  margin: 0.4em;
}
</style>

{{ mathjax() }}

<!-- voila spinner -->
<style>
  #loading {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 75vh;
        color: var(--jp-content-font-color1);
        font-family: sans-serif;
    }

    .spinner {
      animation: rotation 2s infinite linear;
      transform-origin: 50% 50%;
    }

    .spinner-container {
      width: 10%;
    }

    @keyframes rotation {
      from {transform: rotate(0deg);}
      to   {transform: rotate(359deg);}
    }

    .voila-spinner-color1{
      fill:#268380;
    }

    .voila-spinner-color2{
      fill:#f8e14b;
    }
  </style>
{%- endblock html_head_css -%}

{%- block body -%}
{%- block body_header -%}
{% if resources.theme == 'dark' %}

<body class="jp-Notebook theme-dark" data-base-url="{{resources.base_url}}voila/">
  {% else %}

  <body class="jp-Notebook theme-light" data-base-url="{{resources.base_url}}voila/">
    {% endif %}
    <div id="loading">
      <div class="spinner-container">
        <svg class="spinner" data-name="c1" version="1.1" viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <metadata>
            <rdf:RDF>
              <cc:Work rdf:about="">
                <dc:format>image/svg+xml</dc:format>
                <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
                <dc:title>voila</dc:title>
              </cc:Work>
            </rdf:RDF>
          </metadata>
          <title>spin</title>
          <path class="voila-spinner-color1" d="m250 405c-85.47 0-155-69.53-155-155s69.53-155 155-155 155 69.53 155 155-69.53 155-155 155zm0-275.5a120.5 120.5 0 1 0 120.5 120.5 120.6 120.6 0 0 0-120.5-120.5z" />
          <path class="voila-spinner-color2" d="m250 405c-85.47 0-155-69.53-155-155a17.26 17.26 0 1 1 34.51 0 120.6 120.6 0 0 0 120.5 120.5 17.26 17.26 0 1 1 0 34.51z" />
        </svg>
      </div>
      <h2 id="loading_text">Running {{nb_title}}...</h2>
    </div>
    <script>
      var voila_process = function(cell_index, cell_count) {
        var el = document.getElementById("loading_text")
        el.innerHTML = `Executing ${cell_index} of ${cell_count}`
      }
    </script>

    <div id="rendered_cells" style="display: none">
      {%- endblock body_header -%}

      {%- block body_loop -%}
      {# from this point on, the kernel is started #}
      {%- with kernel_id = kernel_start() -%}
      <script id="jupyter-config-data" type="application/json">
        {
          "baseUrl": "{{resources.base_url}}",
          "kernelId": "{{kernel_id}}"
        }
      </script>
      {% set cell_count = nb.cells|length %}
      {#
      Voila is using Jinja's Template.generate method to not render the whole template in one go.
      The current implementation of Jinja will however not yield template snippets if we call a blocks' super()
      Therefore it is important to have the cell loop in the template.
      The issue for Jinja is: https://github.com/pallets/jinja/issues/1044
      #}
      {%- for cell in cell_generator(nb, kernel_id) -%}
      {% set cellloop = loop %}
      {%- block any_cell scoped -%}
      <script>
        voila_process({
          {
            cellloop.index
          }
        }, {
          {
            cell_count
          }
        })
      </script>
      {{ super() }}
      {%- endblock any_cell -%}
      {%- endfor -%}
      {% endwith %}
      {%- endblock body_loop -%}
      {%- block body_footer -%}
    </div>

    <script type="text/javascript">
      (function() {
        // remove the loading element
        var el = document.getElementById("loading")
        el.parentNode.removeChild(el)
        // show the cell output
        el = document.getElementById("rendered_cells")
        el.style.display = 'unset'
      })();
    </script>

  </body>
  {%- endblock body_footer -%}
  <script>
    window.mobilecheck = function() {
      var check = false;
      (function(a) {
        if (
          /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i
          .test(a) ||
          /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i
          .test(a.substr(0, 4))) check = true;
      })(navigator.userAgent || navigator.vendor || window.opera);
      return check;
    };

    var rendered_markdown = document.getElementsByClassName("jp-RenderedMarkdown");

    if (window.mobilecheck()) {
      for (var i = 0; i < rendered_markdown.length; i++) {
        rendered_markdown.item(i).style.fontSize = "110%"
        rendered_markdown.item(i).style.padding = "20px"
      }
    } else {
      for (var i = 0; i < rendered_markdown.length; i++) {
        rendered_markdown.item(i).style.fontSize = "100%"
      }
    }
  </script>
  {%- endblock body -%}