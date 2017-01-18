import React, {Component} from "react";

export default class ExampleApp extends Component {

    componentDidMount() {
        const article = document.getElementsByTagName('article')[0];

        window.addEventListener("mouseup", e => {
            console.log("JS mouseup", e);
            const range = window.getSelection().rangeCount > 0 && window.getSelection().getRangeAt(0);
            if(!range || range.collapsed) {
                console.log("No range");
                return;
            }

            console.log("range", range);

            console.log("result", {
                ns: range.startContainer.parentElement.attributes['data-uid'].value,
                os: range.startOffset,
                ne: range.endContainer.parentElement.attributes['data-uid'].value,
                oe: range.endOffset
            });
        });
        article.addEventListener("touchend", e => console.log("JS touchend", e));
        //window.addEventListener("dblclick", e => console.log("JS dblclick", e));
        //window.addEventListener("pointerup", e => console.log("JS pointerup", e));
    }

    render() {

        return (
            <article>
            <div data-uid="77"
                onClick={(e) => console.log("React onClick", e)}
            >
                This is quite some text... Will it get selected? Will it trigger some events? Which ones will be reacted on???
            </div>
            </article>
        );
    }
}
