import React, {Component} from "react";
import { connect } from "react-redux";

export class ExampleAppComponent extends Component {

    render() {
        return (
            <div>
                <div>{"Outside: " + this.props.clickStatus}</div>
                <button onClick={(e) => this.props.dispatch(toggleClick())}>Click here!</button>
                <WrapperComponent>
                    <div>{"Inside: " + this.props.clickStatus}</div>
                </WrapperComponent>
            </div>
        );
    }
}

export default connect(state => state)(ExampleAppComponent);


class WrapperComponent extends Component {
    render() {
        return this.props.children;
    }
}

const CLICK_TOGGLED = "CLICK_TOGGLED";

function toggleClick() {
    return {
        type: CLICK_TOGGLED
    }
}

const INITIAL_STATE = {
    clickStatus: false
};

function clickStatus(state = INITIAL_STATE.clickStatus, action = {}) {
    switch (action.type) {
        case CLICK_TOGGLED:
            return ! state;
    }
    return state;
}

export function reducers(state = INITIAL_STATE, action = {}){
    return {
        clickStatus: clickStatus(state.clickStatus, action)
    };
};


