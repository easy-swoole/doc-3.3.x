<html lang="{$lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="/Css/document.css">
    <link rel="stylesheet" href="/Css/highlight.css">
    <link rel="stylesheet" href="/Css/markdown.css">
    <script src="/Js/jquery.min.js"></script>
    <script src="/Js/highlight.min.js"></script>
    <script src="/Js/js.cookie.min.js"></script>
    <script src="/Js/global.js"></script>
    <script src="/Js/jquery.mark.min.js"></script>
    {$header}
</head>
<body>
<div class="container">
    <header class="navBar">
        <div class="navInner">
            <img src="/Images/docNavLogo.png" alt="">
            <div class="navInnerRight">
                <div class="navSearch">
                    <input aria-label="Search" autocomplete="off" spellcheck="false" class="" placeholder="" id="SearchValue">
                    <div class="resultList" id="resultList" style="display: none"></div>
                </div>
                <div class="navItem">
                    <div class="dropdown-wrapper">
                        <button type="button" aria-label="Select language" class="dropdown-title">
                            <span class="title">Language</span> <span class="arrow right"></span>
                        </button>
                        <ul class="nav-dropdown" style="display: none;">
                            {foreach from=$allowLanguages item=lang key=key}
                                <li class="dropdown-item">
                                    <a href="javascript:void(0)" data-lang="{$key}" class="nav-link lang-change">{$lang}</a>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <aside class="sideBar">{$sidebar}</aside>
    <section class="mainContent">
        <div class="content markdown-body">{$content}</div>
    </section>
</div>

<script>
    hljs.initHighlightingOnLoad();
    $(function () {
        // 监听菜单点击事件
        $(".sideBar ul>li").on('click', function () {
            $.each($(".sideBar ul>li"), function () {
                $(this).removeClass('active')
            });
            $(this).addClass('active')
        });
        var articles = [];

        $.ajax({
            url: '/keyword{$lang}.json',
            success: function (data) {
                articles = data;
            }
        });


        /**
         * 关键词查找
         * @param keyword
         */
        function searchKeyword(keyword) {
            var result = [];
            articles.forEach(function (value) {
                var score = 0;
                !value.content && (value.content = '');
                var titleCount = value.title.match(new RegExp(keyword, 'g'));
                var contentCount = value.content.match(new RegExp(keyword, 'g'));
                if ( titleCount && titleCount.length > 0 ) {
                    score += titleCount.length * 100;
                } else if ( contentCount && contentCount.length > 0 ) {
                    score += contentCount.length;
                }

                // 截取内容前后字符
                var contentDesc = '';
                if ( contentCount ) {
                    var keywordIndex = value.content.indexOf(keyword);
                    contentDesc += value.content.slice(keywordIndex - 10, keywordIndex);
                    contentDesc += "<span class='searchKeyword'>" + keyword + "</span>";
                    contentDesc += value.content.slice(keywordIndex + keyword.length, keywordIndex + 30);
                }

                if ( score > 0 ) {
                    var searchResult = {
                        score: score,
                        hitType: titleCount ? 'title' : 'content',
                        title: value.title,
                        link: value.link,
                        contentDesc: titleCount ? value.title : contentDesc + '...',
                    };

                    result.push(searchResult);
                }
            });
            // 结果排序
            result.sort(function (a, b) {
                return b.score - a.score;
            });

            // 生成目标Dom
            var searchDom = '';
            result.forEach(function (value) {
                var dom = [
                    '<div class="resultItem">',
                    '<a href="' + value.link + '" class="resultLink">',
                    '<div class="resultTitle">' + value.title + '</div>',
                    value.hitType !== 'title' ? '<div class="resultDesc">' + value.contentDesc + '</div>' : '',
                    '</a></div>'
                ];
                searchDom += dom.join('');
            });

            $('#resultList').html(searchDom).show(100);
        }

        // 事件防抖
        function debounce(func, wait) {
            let timer;
            return function () {
                let context = this; // 注意 this 指向
                let args = arguments; // arguments中存着e
                if ( timer ) clearTimeout(timer);
                timer = setTimeout(() => {
                    func.apply(this, args)
                }, wait)
            }
        }

        // 搜索输入事件
        $('#SearchValue').on('input', debounce(function (e) {
            searchKeyword($('#SearchValue').val())
        }, 300)).on('blur', function () {
            $('#resultList').hide();
        });

        // 阻止冒泡使得点击条目时不视为失去焦点
        $('#resultList').on('mousedown', function (e) {
            e.preventDefault();
        });

        // 切换中英文
        $('.dropdown-title').click(function (e) {
            $('.nav-dropdown').toggle();
        })

        $('.lang-change').click(function (e) {
            var lang = $(this).data('lang');
            Cookies.set('language', lang);
            window.location.reload();
        });

        // 自动展开菜单父级
        $.each($('.sideBar ul li a'), function () {
            if ( $(this).attr('href') === window.location.pathname ) {
                console.warn($(this).parents('li').last().addClass('active'));
            }
        });

        // 拦截菜单点击事件切换右侧内容
        $('.sideBar ul li a').on('click', function () {
            var href = $(this).attr('href');
            window.history.pushState(null,null,href);
            $.ajax({
                url: href,
                method: 'POST',
                success: function (res) {
                    $('title').text($(res).find('title').eq(0).text());
                    $('.markdown-body').html($(res).find('.markdown-body').eq(0).html());
                    hljs.initHighlighting.called = false;
                    hljs.initHighlighting();
                    window.scrollTo(0, 0)
                }
            });
            return false;
        })
    })
</script>
</body>
</html>
