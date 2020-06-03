from pathlib import Path
import ipywidgets as widgets


def render_audio_sample(name, label="Listen here:", container=widgets.HBox):
    return container(
        [
            widgets.Label(value=label),
            widgets.Audio.from_file(
                Path("audio") / "{}.mp3".format(name), autoplay=False
            ),
        ]
    )
