{block:Title}
<h1>{Title}</h1>
{/block:Title}
<section class="body">
{block:Lines}
  <div class="line {Alt}">
    {block:Label}
      <label>{Label}</label>
    {/block:Label}
    <span class="name user-{UserNumber}">{Name}</span>
    <span class="phrase">{Line}</span>
  </div>
{/block:Lines}
</section>
